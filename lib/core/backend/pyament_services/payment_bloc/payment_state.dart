import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:flutter/foundation.dart';

enum PaymentStates { noEvents, loading, failed }

@immutable
class PaymentState {
  final List<String>? providers;
  final List<CartItem>? cartItems;
  final PaymentStates states;

  const PaymentState({
    this.providers,
    this.cartItems,
    this.states = PaymentStates.noEvents,
  });

  PaymentState copyWith({
    List<String>? providers,
    List<CartItem>? cartItems,
    PaymentStates? states,
  }) {
    return PaymentState(
      providers: providers ?? this.providers,
      cartItems: cartItems ?? this.cartItems,
      states: states ?? this.states,
    );
  }
}
