import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class PaymentEventPay extends PaymentEvent {
  final String provider;
  final List<CartItem> cartItems;
  PaymentEventPay({required this.provider, required this.cartItems});
}

class PaymentEventListen extends PaymentEvent {
  final List<CartItem> cartItems;
  PaymentEventListen({required this.cartItems});
}

class PaymentEventOnAppBackToLive extends PaymentEvent {
  final List<String> cartItemIds;
  PaymentEventOnAppBackToLive({required this.cartItemIds});
}

class PaymentEventSilence extends PaymentEvent {}
