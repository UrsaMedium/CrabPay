import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class InnerCartHandler {
  Future<List<CartItem>> fetchCartItems(String userId);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> deleteCartItem(String cartItemId);
}
