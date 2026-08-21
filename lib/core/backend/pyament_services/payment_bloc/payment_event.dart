import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class PaymentEventPay extends PaymentEvent {
  final String provider;
  final List<CartItem> cartItems;
  PaymentEventPay({required this.provider, required this.cartItems});
}

class PaymentEventReturnToProvider extends PaymentEvent {
  final String link;
  PaymentEventReturnToProvider({required this.link});
}
