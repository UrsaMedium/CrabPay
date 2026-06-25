import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class InnerCartHandler {
  Future<List<CartItem>> fetchCartItems(String userId);
  Stream<List<CartItem>> cartItemsStream(String userId);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> deleteCartItem(String cartItemId);
  Future<void> updateCartItem(List<CartItem> cartItems, AuthUser? user);
}
