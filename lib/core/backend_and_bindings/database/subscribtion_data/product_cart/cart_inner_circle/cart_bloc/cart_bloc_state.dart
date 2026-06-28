import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:flutter/foundation.dart' show immutable;

enum CartStates {
  empty,
  adding,
  added,
  failedToAdd,
  deleting,
  deleted,
  failedToDelete,
  getting,
  got,
  failedToGet,
  streamEvent,
  userCheckouts,
  signedOutUserCheckouts,
  fetchedProductCartItemCount,
  fetchedUserCartItemCount,
  faildFetchedProductCartItemCount,
  faildFetchedUserCartItemCount,
}

enum IsStreaming { yes, no }

@immutable
class CartState {
  final IsStreaming isStreaming;
  final List<CartItem>? cartItems;
  final List<CartItem>? allUserCartItems;
  final List<CartItem>? cartItemsFromSignedOutUser;
  final CartItem? cartItemToPush;
  final CartStates states;
  final int? productCartItemAmount;
  final int? userCartItemAmount;
  const CartState({
    this.cartItems,
    this.states = CartStates.empty,
    this.cartItemToPush,
    this.isStreaming = IsStreaming.no,
    this.cartItemsFromSignedOutUser,
    this.allUserCartItems,
    this.productCartItemAmount,
    this.userCartItemAmount,
  });

  CartState flushData() {
    return CartState();
  }

  CartState copyWith({
    List<CartItem>? cartItems,
    List<CartItem>? allUserCartItems,
    List<CartItem>? cartItemsFromSignedOutUser,
    CartStates? states,
    CartItem? cartItemToPush,
    IsStreaming? isStreaming,
    int? productCartItemAmount,
    int? userCartItemAmount,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      allUserCartItems: allUserCartItems ?? this.allUserCartItems,
      cartItemsFromSignedOutUser:
          cartItemsFromSignedOutUser ?? this.cartItemsFromSignedOutUser,
      cartItemToPush: cartItemToPush ?? this.cartItemToPush,
      states: states ?? this.states,
      isStreaming: isStreaming ?? this.isStreaming,
      productCartItemAmount:
          productCartItemAmount ?? this.productCartItemAmount,
      userCartItemAmount: userCartItemAmount ?? this.userCartItemAmount,
    );
  }
}
