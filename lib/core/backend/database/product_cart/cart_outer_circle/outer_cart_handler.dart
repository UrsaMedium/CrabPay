import 'dart:async';

import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';

class OuterCartHandler implements InnerCartHandler {
  final retryer = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(milliseconds: 500),
  );

  List<CartItem> dataCasting(
    List<GetCartItemsQueryCartItems> fetchedCartItems,
  ) {
    List<CartItem> cartItems = [];
    for (var item in fetchedCartItems) {
      final purchaseData = Map<String, String>.from(item.purchaseData.toJson());
      cartItems.add(
        CartItem(
          id: item.id,
          userId: item.userId,
          userName: item.userName,
          productId: item.productId,
          productName: item.productName,
          purchaseData: purchaseData,
          currency: item.currency,
          checkoutPrice: item.checkoutPrice,
          status: item.status,
        ),
      );
    }
    return cartItems;
  }

  @override
  Future<List<CartItem>> fetchCartItems(String userId) async {
    try {
      final fetchedCartItems = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getCartItemsQuery(userId: userId)
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      return dataCasting(fetchedCartItems.data.cartItems);
    } catch (e) {
      print('Failed to fetch cart items: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch cart items: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteCartItem(id: cartItemId)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete the cart item: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the cart item: $e');
      rethrow;
    }
  }

  @override
  Future<void> addCartItem(CartItem cartItem) async {
    try {
      final purchaseData = AnyValue(
        cartItem.purchaseData.cast<String, String>(),
      );
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addCartItem(
              userId: cartItem.userId,
              userName: cartItem.userName,
              productId: cartItem.productId,
              productName: cartItem.productName,
              purchaseData: purchaseData,
              currency: cartItem.currency,
              checkoutPrice: cartItem.checkoutPrice,
              status: cartItem.status,
            )
            .comment(cartItem.comment)
            .execute(),
      );
    } catch (e) {
      print('Failed to add the cart item: $e');
      Fluttertoast.showToast(msg: 'Failed to add the cart item: $e');
      rethrow;
    }
  }

  @override
  Stream<List<CartItem>> cartItemsStream(String userId) {
    return CrabpayConnectorConnector.instance
        .getCartItemsQuery(userId: userId)
        .ref()
        .subscribe()
        .map((event) {
          final fetchedCartItems = event.data.cartItems;
          return dataCasting(fetchedCartItems);
        });
  }

  @override
  Future<void> updateCartItem(List<CartItem> cartItems, AuthUser? user) async {
    try {
      if (user == null) {
        for (var item in cartItems) {
          await retryer.retry(
            () => CrabpayConnectorConnector.instance
                .updateCartItem(id: item.id)
                .status('beingCheckedOut')
                .statusChangedAt(
                  Timestamp.fromJson(DateTime.now().toUtc().toIso8601String()),
                )
                .execute(),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getProductCartItemAmount(String userId, String productId) async {
    try {
      final fetchedAmount = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getProductCartCount(userId: userId, productId: productId)
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      final amount = fetchedAmount.data.ofUserOfProductCartItemCounters;
      if (amount.isEmpty) return 0;
      return amount.first.productCartItemCount ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUserCartItemAmount(String userId) async {
    try {
      final fetchedAmount = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getUserCartCount(userId: userId)
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      final amount = fetchedAmount.data.ofUserCartItemCounters;
      if (amount.isEmpty) return 0;
      return amount.first.userCartItemCount ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deletedLastAddedProductCartItem(
    String userId,
    String productId,
  ) async {
    try {
      final tryDelete = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteLastAddedProductCartItem(
              userId: userId,
              productId: productId,
            )
            .execute(),
      );
      final rowsDeleted = tryDelete.data.execute_ ?? 0;
      return rowsDeleted > 0;
    } catch (e) {
      rethrow;
    }
  }
}
