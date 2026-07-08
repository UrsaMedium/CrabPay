import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_cart_item.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_cart_item.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_update_cart_item.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_all_cart_items.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_cart_count.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_product_cart_count.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_last_added_product_cart_item.dart';
import 'package:retry/retry.dart';

class OuterCartHandlerWithCustomPostgresServer implements InnerCartHandler {
  final retryer = RetryOptions(
    maxAttempts: 3,
    delayFactor: const Duration(milliseconds: 300),
  );

  @override
  Future<void> addCartItem(CartItem cartItem) async {
    try {
      await retryer.retry(
        () => MutationAddCartItem(
          userId: cartItem.userId,
          userName: cartItem.userName,
          productId: cartItem.productId,
          productName: cartItem.productName,
          purchaseData: cartItem.purchaseData,
          currency: cartItem.currency,
          checkoutPrice: cartItem.checkoutPrice,
          status: cartItem.status,
          comment: cartItem.comment,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> fetchCartItems(String userId) async {
    try {
      return await retryer.retry(
        () => QueryGetCartItems().execute(userId: userId),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUserCartItemAmount(String userId) async {
    return await retryer.retry(
      () => QueryGetUserCartCount().execute(userId: userId),
    );
  }

  @override
  Future<int> getProductCartItemAmount(String userId, String productId) async {
    return await retryer.retry(
      () => QueryGetProductCartCount().execute(
        userId: userId,
        productId: productId,
      ),
    );
  }

  @override
  Future<bool> deletedLastAddedProductCartItem(
    String userId,
    String productId,
  ) async {
    try {
      await retryer.retry(
        () => MutationDeleteLastAddedProductCartItem(
          userId: userId,
          productId: productId,
        ).execute(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // These will require creating corresponding SQL classes following the same pattern.
  @override
  Stream<List<CartItem>> cartItemsStream(String userId) {
    throw UnimplementedError('Streaming implementation pending');
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      await retryer.retry(
        () => MutationDeleteCartItem(id: cartItemId).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCartItem(List<CartItem> cartItems, AuthUser? user) async {
    try {
      for (var item in cartItems) {
        await retryer.retry(
          () => MutationUpdateCartItem(
            id: item.id,
            userId: user!.id,
            checkoutPrice: item.checkoutPrice,
            comment: item.comment,
            currency: item.currency,
            productId: item.productId,
            productName: item.productName,
            purchaseData: item.purchaseData,
            status: item.status,
            userName: user.email,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
