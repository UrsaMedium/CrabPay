import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartEventAddCartItem extends CartEvent {
  final String userId;
  final CartItem cartItem;
  const CartEventAddCartItem({required this.cartItem, required this.userId});
}

class CartEventFetchCartItems extends CartEvent {
  final String userId;
  CartEventFetchCartItems({required this.userId});
}

class CartEventDeleteCartItem extends CartEvent {
  final String userId;
  final CartItem cartItem;
  const CartEventDeleteCartItem({required this.cartItem, required this.userId});
}

class CartEventDeleteCartItemById extends CartEvent {
  final String cartItemId;
  const CartEventDeleteCartItemById({required this.cartItemId});
}

class CartEventUserCheckoutItems extends CartEvent {
  final List<CartItem> checkoutItems;
  final String? comment;
  final String status;
  CartEventUserCheckoutItems({
    required this.checkoutItems,
    this.comment,
    required this.status,
  });
}

class CartEventSignedOutUserCheckoutItems extends CartEvent {
  final List<CartItem> checkoutItems;
  final String? comment;
  final String status;
  CartEventSignedOutUserCheckoutItems({
    required this.checkoutItems,
    this.comment,
    required this.status,
  });
}

class CartEventFlushData extends CartEvent {}

class CartEventStartCartItemsStream extends CartEvent {
  final String userId;
  CartEventStartCartItemsStream({required this.userId});
}

class CartEventOnChangeStreamed extends CartEvent {
  final List<CartItem> cartItems;
  CartEventOnChangeStreamed({required this.cartItems});
}

class CartEventCloseStream extends CartEvent {}

class CartEventFetchProductCartItemAmount extends CartEvent {
  final String userId;
  final String productId;
  CartEventFetchProductCartItemAmount({
    required this.userId,
    required this.productId,
  });
}

class CartEventFetchUserCartItemAmount extends CartEvent {
  final String userId;
  CartEventFetchUserCartItemAmount({required this.userId});
}

class CartEventDeleteLastAddedProductCartItem extends CartEvent {
  final String userId;
  final String productId;
  CartEventDeleteLastAddedProductCartItem({
    required this.userId,
    required this.productId,
  });
}
