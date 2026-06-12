import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OuterCartHandler implements InnerCartHandler {
  @override
  Future<List<CartItem>> fetchCartItems(String userId) async {
    try {
      final fetchedCartItems = await CrabpayConnectorConnector.instance
          .getCartItemsQuery(userId: userId)
          .execute();
      List<CartItem> cartItems = [];
      for (var item in fetchedCartItems.data.cartItems) {
        final purchaseData = Map<String, String>.from(
          item.purchaseData.toJson(),
        );
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
    } catch (e) {
      print('Failed to fetch cart items: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch cart items: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      CrabpayConnectorConnector.instance
          .deleteCartItem(id: cartItemId)
          .execute();
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
      print('ooo');
      print(cartItem);
      CrabpayConnectorConnector.instance
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
          .execute();
      print('ahh');
    } catch (e) {
      print('Failed to add the cart item: $e');
      Fluttertoast.showToast(msg: 'Failed to add the cart item: $e');
      rethrow;
    }
  }
}
