import 'package:crabpay/core/backend/common/paginated_result_data_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:equatable/equatable.dart';
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
  updatedUserCartItemCount,
  faildFetchedProductCartItemCount,
  faildToFetchUserCartItemCount,
  deletedLastAddedProductCartItem,
  failedToDeleteLastAddedProductCartItem,
  searchedOrders,
}

enum IsCartStreamingUserCarItemAmount { yes, no }

enum PendingOrdersState { streaming, notStreaming, updated, error }

@immutable
class CartState extends Equatable {
  final IsCartStreamingUserCarItemAmount isCartStreaming;
  final List<CartItem>? cartItemsToBuy;
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
  //pending oredrs
  final PendingOrdersState pendingOrdersState;
  final List<PendingOrder>? pendingOrders;

  const CartState({
    this.cartItemsToBuy,
    this.states = CartStates.empty,
    this.cartItemToPush,
    this.isCartStreaming = IsCartStreamingUserCarItemAmount.no,
    this.productCartItemAmount,
    this.userCartItemAmount,
    this.notDeliveredOrders,
    this.itemsOfNotDeliveredOrders,
    this.deliveredOrders,
    this.itemsOfDeliveredOrders,
    this.searchedOrders,
    this.itemsOfSearchedOrders,
    this.pendingOrdersState = PendingOrdersState.notStreaming,
    this.pendingOrders,
  });

  CartState copyWith({
    List<CartItem>? cartItemsToBuy,
    List<CartItem>? cartItemsFromSignedOutUser,
    PaginatedResult<String>? notDeliveredOrders,
    PaginatedResult<String>? deliveredOrders,
    PaginatedResult<String>? searchedOrders,
    Map<String, List<CartItem>>? itemsOfNotDeliveredOrders,
    Map<String, List<CartItem>>? itemsOfDeliveredOrders,
    Map<String, List<CartItem>>? itemsOfSearchedOrders,
    CartStates? states,
    CartItem? cartItemToPush,
    IsCartStreamingUserCarItemAmount? isCartStreaming,
    int? productCartItemAmount,
    int? userCartItemAmount,
    PendingOrdersState? pendingOrdersState,
    List<PendingOrder>? pendingOrders,
  }) {
    return CartState(
      states: states ?? this.states,
      isCartStreaming: isCartStreaming ?? this.isCartStreaming,
      pendingOrdersState: pendingOrdersState ?? this.pendingOrdersState,
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
      pendingOrders: pendingOrders == null
          ? this.pendingOrders
          : pendingOrders.isEmpty
          ? null
          : pendingOrders,
    );
  }

  @override
  List<Object?> get props => [
    cartItemsToBuy,
    states,
    cartItemToPush,
    isCartStreaming,
    productCartItemAmount,
    userCartItemAmount,
    notDeliveredOrders,
    itemsOfNotDeliveredOrders,
    deliveredOrders,
    itemsOfDeliveredOrders,
    searchedOrders,
    itemsOfSearchedOrders,
    pendingOrders,
    pendingOrdersState,
  ];
}
