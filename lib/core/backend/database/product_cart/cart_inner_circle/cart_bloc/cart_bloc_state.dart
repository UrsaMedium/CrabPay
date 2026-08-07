import 'package:crabpay/core/backend/common/paginated_result_data_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:flutter/foundation.dart' show immutable;

enum CartStates {
  loading,
  empty,
  added,
  failedToAdd,
  deleted,
  failedToDelete,
  got,
  loadedMoreOrdersNotDeliveredOrders,
  loadedMoreOrdersDeliveredOrders,
  failedToGet,
  streamEvent,
  userCheckouts,
  signedOutUserCheckouts,
  fetchedProductCartItemCount,
  fetchedUserCartItemCount,
  faildFetchedProductCartItemCount,
  faildToFetchUserCartItemCount,
  deletedLastAddedProductCartItem,
  failedToDeleteLastAddedProductCartItem,
}

enum IsCartStreaming { yes, no }

@immutable
class CartState {
  final IsCartStreaming isCartStreaming;
  final List<CartItem>? cartItemsToBuy;
  final List<CartItem>? cartItemsOnPaymentState;
  final PaginatedResult<String>? notDeliveredOrders;
  final PaginatedResult<String>? deliveredOrders;
  final Map<String, List<CartItem>>? itemsOfNotDeliveredOrder;
  final Map<String, List<CartItem>>? itemsOfDeliveredOrder;
  final CartItem? cartItemToPush;
  final CartStates states;
  final int? productCartItemAmount;
  final int? userCartItemAmount;
  const CartState({
    this.cartItemsToBuy,
    this.states = CartStates.empty,
    this.cartItemToPush,
    this.isCartStreaming = IsCartStreaming.no,
    this.productCartItemAmount,
    this.userCartItemAmount,
    this.notDeliveredOrders,
    this.itemsOfNotDeliveredOrder,
    this.cartItemsOnPaymentState,
    this.deliveredOrders,
    this.itemsOfDeliveredOrder,
  });

  CartState copyWith({
    List<CartItem>? cartItemsToBuy,
    List<CartItem>? cartItemsOnPaymentState,
    List<CartItem>? cartItemsFromSignedOutUser,
    PaginatedResult<String>? notDeliveredOrders,
    PaginatedResult<String>? deliveredOrders,
    Map<String, List<CartItem>>? itemsOfNotDeliveredOrder,
    Map<String, List<CartItem>>? itemsOfDeliveredOrder,
    CartStates? states,
    CartItem? cartItemToPush,
    IsCartStreaming? isCartStreaming,
    int? productCartItemAmount,
    int? userCartItemAmount,
  }) {
    return CartState(
      cartItemsToBuy: cartItemsToBuy ?? this.cartItemsToBuy,
      cartItemToPush: cartItemToPush ?? this.cartItemToPush,
      states: states ?? this.states,
      isCartStreaming: isCartStreaming ?? this.isCartStreaming,
      productCartItemAmount:
          productCartItemAmount ?? this.productCartItemAmount,
      userCartItemAmount: userCartItemAmount ?? this.userCartItemAmount,
      itemsOfNotDeliveredOrder:
          itemsOfNotDeliveredOrder ?? this.itemsOfNotDeliveredOrder,
      notDeliveredOrders: notDeliveredOrders ?? this.notDeliveredOrders,
      cartItemsOnPaymentState:
          cartItemsOnPaymentState ?? this.cartItemsOnPaymentState,
      deliveredOrders: deliveredOrders ?? this.deliveredOrders,
      itemsOfDeliveredOrder:
          itemsOfDeliveredOrder ?? this.itemsOfDeliveredOrder,
    );
  }
}
