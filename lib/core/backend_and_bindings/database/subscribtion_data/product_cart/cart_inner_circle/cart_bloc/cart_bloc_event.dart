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

class CartEventDeleteCartItemById implements CartEvent {
  final String cartItemId;
  const CartEventDeleteCartItemById({required this.cartItemId});
}

class CartEventUserCheckoutItems implements CartEvent {
  final List<CartItem> checkoutItems;
  final String? comment;
  final String status;
  CartEventUserCheckoutItems({
    required this.checkoutItems,
    this.comment,
    required this.status,
  });
}

class CartEventSignedOutUserCheckoutItems implements CartEvent {
  final List<CartItem> checkoutItems;
  final String? comment;
  final String status;
  CartEventSignedOutUserCheckoutItems({
    required this.checkoutItems,
    this.comment,
    required this.status,
  });
}

class CartEventFlushData implements CartEvent {}

class CartEventStartCartItemsStream implements CartEvent {
  final String userId;
  CartEventStartCartItemsStream({required this.userId});
}

class CartEventOnChangeStreamed implements CartEvent {
  final List<CartItem> cartItems;
  CartEventOnChangeStreamed({required this.cartItems});
}

class CartEventCloseStream implements CartEvent {}

class CartEventFetchProductCartItemAmount implements CartEvent {
  final String userId;
  final String productId;
  CartEventFetchProductCartItemAmount({
    required this.userId,
    required this.productId,
  });
}

class CartEventFetchUserCartItemAmount implements CartEvent {
  final String userId;
  CartEventFetchUserCartItemAmount({required this.userId});
}

class CartEventDeleteLastAddedProductCartItem implements CartEvent {
  final String userId;
  final String productId;
  CartEventDeleteLastAddedProductCartItem({
    required this.userId,
    required this.productId,
  });
}
