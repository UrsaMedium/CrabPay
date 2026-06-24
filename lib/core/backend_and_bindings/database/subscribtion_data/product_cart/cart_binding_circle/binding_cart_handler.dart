import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_outer_circle/outer_cart_handler.dart';

class BindingCartHandler implements InnerCartHandler {
  final InnerCartHandler cartHandler;
  BindingCartHandler({required this.cartHandler});

  factory BindingCartHandler.firebaseCartDb() =>
      BindingCartHandler(cartHandler: (OuterCartHandler()));

  @override
  Future<List<CartItem>> fetchCartItems(String userId) =>
      cartHandler.fetchCartItems(userId);

  @override
  Future<void> deleteCartItem(String cartItemId) =>
      cartHandler.deleteCartItem(cartItemId);

  @override
  Future<void> addCartItem(CartItem cartItem) =>
      cartHandler.addCartItem(cartItem);

  @override
  Stream<List<CartItem>> cartItemsStream(String userId) =>
      cartHandler.cartItemsStream(userId);
}
