import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';

abstract class CartEvent {
  const CartEvent();
}

//add item
class CartEventAddCartItem extends CartEvent {
  final String userId;
  final CartItem cartItem;
  const CartEventAddCartItem({required this.cartItem, required this.userId});
}

//fetch items
class CartEventFetchCartItems extends CartEvent {
  final String userId;
  CartEventFetchCartItems({required this.userId});
}

//delete item
class CartEventDeleteCartItem extends CartEvent {
  final String userId;
  final CartItem cartItem;
  const CartEventDeleteCartItem({required this.cartItem, required this.userId});
}

// flush data
class CartEventFlushData extends CartEvent {}

//close stream
class CartEventCloseStream extends CartEvent {}

//fetch amount of items of a certain product
class CartEventFetchProductCartItemAmount extends CartEvent {
  final String userId;
  final String productId;
  CartEventFetchProductCartItemAmount({
    required this.userId,
    required this.productId,
  });
}

// start sreaming total amount of items in a user's cart
class CartEventStartStreamUserCartItemAmount extends CartEvent {
  final String userId;
  CartEventStartStreamUserCartItemAmount({required this.userId});
}

// helper for the stream
class CartEventUpdateUserCartItemAmountFromStream extends CartEvent {
  final int amount;
  CartEventUpdateUserCartItemAmountFromStream({required this.amount});
}

// fetch orders from orders view which are not delivered
class CartEventFetchNotDeliveredOrders extends CartEvent {
  final String userId;
  final String? pageToken;
  CartEventFetchNotDeliveredOrders({
    required this.userId,
    required this.pageToken,
  });
}

// fetch orders from orders view which are delivered
class CartEventFetchDeliveredOrders extends CartEvent {
  final String userId;
  final String? pageToken;
  CartEventFetchDeliveredOrders({
    required this.userId,
    required this.pageToken,
  });
}

// flush orders
class CartEventFlushOrders extends CartEvent {}

// fetch items that are waiting for a payment
class CartEventFetchCartItemsOnPaymentState extends CartEvent {
  final String userId;
  CartEventFetchCartItemsOnPaymentState({required this.userId});
}

// delete last added item of a certain product
class CartEventDeleteLastAddedProductCartItem extends CartEvent {
  final String userId;
  final String productId;
  CartEventDeleteLastAddedProductCartItem({
    required this.userId,
    required this.productId,
  });
}
