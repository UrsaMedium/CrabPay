import 'package:crabpay/core/backend/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class PaymentEventPay implements PaymentEvent {
  final String provider;
  final List<CartItem> cartItems;
  PaymentEventPay({required this.provider, required this.cartItems});
}

class PaymentEventLaunchLink implements PaymentEvent {}

class PaymentEventListenToStatus implements PaymentEvent {}

class PaymentEventSetStatus implements PaymentEvent {}
