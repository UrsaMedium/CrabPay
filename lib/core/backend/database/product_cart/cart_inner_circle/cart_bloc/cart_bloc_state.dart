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
  searchedOrders
}

enum IsCartStreaming { yes, no }

@immutable
class CartState {
  final IsCartStreaming isCartStreaming;
  final List<CartItem>? cartItemsToBuy;
  final List<CartItem>? cartItemsOnPaymentState;
  final PaginatedResult<String>? notDeliveredOrders;
  final PaginatedResult<String>? deliveredOrders;
  final PaginatedResult<String>? searchedOrders;
  final Map<String, List<CartItem>>? itemsOfNotDeliveredOrders;
  final Map<String, List<CartItem>>? itemsOfDeliveredOrders;
  final Map<String, List<CartItem>>? itemsOfSearchedOrders;
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
    this.itemsOfNotDeliveredOrders,
    this.cartItemsOnPaymentState,
    this.deliveredOrders,
    this.itemsOfDeliveredOrders,
    this.searchedOrders,
    this.itemsOfSearchedOrders,
  });

  CartState copyWith({
    List<CartItem>? cartItemsToBuy,
    List<CartItem>? cartItemsOnPaymentState,
    List<CartItem>? cartItemsFromSignedOutUser,
    PaginatedResult<String>? notDeliveredOrders,
    PaginatedResult<String>? deliveredOrders,
    PaginatedResult<String>? searchedOrders,
    Map<String, List<CartItem>>? itemsOfNotDeliveredOrders,
    Map<String, List<CartItem>>? itemsOfDeliveredOrders,
    Map<String, List<CartItem>>? itemsOfSearchedOrders,
    CartStates? states,
    CartItem? cartItemToPush,
    IsCartStreaming? isCartStreaming,
    int? productCartItemAmount,
    int? userCartItemAmount,
  }) {
    return CartState(
      states: states ?? this.states,
      isCartStreaming: isCartStreaming ?? this.isCartStreaming,
      //
      cartItemsToBuy: cartItemsToBuy == null
          ? this.cartItemsToBuy
          : cartItemsToBuy.isEmpty
          ? null
          : cartItemsToBuy,
      cartItemToPush: cartItemToPush == null
          ? this.cartItemToPush
          : cartItemToPush.productId.isEmpty
          ? null
          : cartItemToPush,
      productCartItemAmount: productCartItemAmount == null
          ? this.productCartItemAmount
          : productCartItemAmount == -1
          ? null
          : productCartItemAmount,
      userCartItemAmount: userCartItemAmount == null
          ? this.userCartItemAmount
          : userCartItemAmount == -1
          ? null
          : userCartItemAmount,
      itemsOfNotDeliveredOrders: itemsOfNotDeliveredOrders == null
          ? this.itemsOfNotDeliveredOrders
          : itemsOfNotDeliveredOrders.isEmpty
          ? null
          : itemsOfNotDeliveredOrders,
      notDeliveredOrders: notDeliveredOrders == null
          ? this.notDeliveredOrders
          : notDeliveredOrders.objects.isEmpty
          ? null
          : notDeliveredOrders,
      deliveredOrders: deliveredOrders == null
          ? this.deliveredOrders
          : deliveredOrders.objects.isEmpty
          ? null
          : deliveredOrders,
      itemsOfDeliveredOrders: itemsOfDeliveredOrders == null
          ? this.itemsOfDeliveredOrders
          : itemsOfDeliveredOrders.isEmpty
          ? null
          : itemsOfDeliveredOrders,
      searchedOrders: searchedOrders == null
          ? this.searchedOrders
          : searchedOrders.objects.isEmpty
          ? null
          : searchedOrders,
      itemsOfSearchedOrders: itemsOfSearchedOrders == null
          ? this.itemsOfSearchedOrders
          : itemsOfSearchedOrders.isEmpty
          ? null
          : itemsOfSearchedOrders,
      cartItemsOnPaymentState: cartItemsOnPaymentState == null
          ? this.cartItemsOnPaymentState
          : cartItemsOnPaymentState.isEmpty
          ? null
          : cartItemsOnPaymentState,
    );
  }
}
