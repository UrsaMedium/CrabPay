import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:flutter/foundation.dart' show immutable;

enum CartStates { empty, adding, deleting, getting }

@immutable
class CartState {
  final List<CartItem>? cartItems;
  final CartItem? cartItemToPush;
  final CartStates states;
  const CartState({
    this.cartItems,
    this.states = CartStates.empty,
    this.cartItemToPush,
  });

  CartState copyWith({
    List<CartItem>? cartItems,
    CartStates? states,
    CartItem? cartItemToPush,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      cartItemToPush: cartItemToPush ?? this.cartItemToPush,
      states: states ?? this.states,
    );
  }
}
