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

enum IsStreaming { yes, no }

@immutable
class CartState {
  final IsStreaming isStreaming;
  final List<CartItem>? cartItemsToBuy;
  final List<CartItem>? cartItemsProccessed;
  final List<CartItem>? allUserCartItems;
  final CartItem? cartItemToPush;
  final CartStates states;
  final int? productCartItemAmount;
  final int? userCartItemAmount;
  const CartState({
    this.cartItemsToBuy,
    this.states = CartStates.empty,
    this.cartItemToPush,
    this.isStreaming = IsStreaming.no,
    this.allUserCartItems,
    this.productCartItemAmount,
    this.userCartItemAmount,
    this.cartItemsProccessed,
  });

  CartState copyWith({
    List<CartItem>? cartItemsToBuy,
    List<CartItem>? cartItemsProccessed,
    List<CartItem>? allUserCartItems,
    List<CartItem>? cartItemsFromSignedOutUser,
    CartStates? states,
    CartItem? cartItemToPush,
    IsStreaming? isStreaming,
    int? productCartItemAmount,
    int? userCartItemAmount,
  }) {
    return CartState(
      cartItemsToBuy: cartItemsToBuy ?? this.cartItemsToBuy,
      cartItemsProccessed: cartItemsProccessed ?? this.cartItemsProccessed,
      allUserCartItems: allUserCartItems ?? this.allUserCartItems,
      cartItemToPush: cartItemToPush ?? this.cartItemToPush,
      states: states ?? this.states,
      isStreaming: isStreaming ?? this.isStreaming,
      productCartItemAmount:
          productCartItemAmount ?? this.productCartItemAmount,
      userCartItemAmount: userCartItemAmount ?? this.userCartItemAmount,
    );
  }
}
