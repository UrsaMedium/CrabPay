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
  final PaginatedResult<String>? orders;
  final Map<String, List<CartItem>>? itemsOfOrder;
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
    this.orders,
    this.itemsOfOrder,
    this.cartItemsOnPaymentState,
  });

  CartState copyWith({
    List<CartItem>? cartItemsToBuy,
    List<CartItem>? cartItemsOnPaymentState,
    List<CartItem>? cartItemsFromSignedOutUser,
    PaginatedResult<String>? orders,
    Map<String, List<CartItem>>? itemsOfOrder,
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
      itemsOfOrder: itemsOfOrder ?? this.itemsOfOrder,
      orders: orders ?? this.orders,
      cartItemsOnPaymentState:
          cartItemsOnPaymentState ?? this.cartItemsOnPaymentState,
    );
  }
}
