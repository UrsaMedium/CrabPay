import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CartEvent {
  const CartEvent();
}

class CartEventAddCartItem implements CartEvent {
  final String userId;
  final CartItem cartItem;
  const CartEventAddCartItem({required this.cartItem, required this.userId});
}

class CartEventFetchCartItems implements CartEvent {
  final String userId;
  CartEventFetchCartItems({required this.userId});
}

class CartEventDeleteCartItem implements CartEvent {
  final CartItem cartItem;
  const CartEventDeleteCartItem({required this.cartItem});
}
