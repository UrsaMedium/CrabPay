import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

class PendingOrder {
  final String paymentId;
  final String userId;
  final String paymentLink;
  final double totalPrice;
  final List<CartItem> cartItems;

  PendingOrder({
    required this.paymentId,
    required this.userId,
    required this.paymentLink,
    required this.cartItems,
    required this.totalPrice,
  });

  factory PendingOrder.initial() => PendingOrder(
    paymentId: '',
    userId: '',
    paymentLink: '',
    totalPrice: 0,
    cartItems: [],
  );
}
