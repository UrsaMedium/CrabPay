import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class InnerCartHandler {
  Future<List<CartItem>> fetchCartItems(String userId);
  Stream<List<CartItem>> cartItemsStream(String userId);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> deleteCartItem(String cartItemId);
  Future<void> updateCartItem(List<CartItem> cartItems, AppAuthUser? user);
  Future<int> getProductCartItemAmount(String userId, String productId);
  Future<int> getUserCartItemAmount(String userId);
  Future<bool> deleteLastAddedProductCartItem(String userId, String productId);
}
