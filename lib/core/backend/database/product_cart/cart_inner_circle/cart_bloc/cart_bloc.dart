import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  StreamSubscription? _streamSubscription;
  CartBloc(InnerCartHandler cartHandler) : super(const CartState()) {
    on<CartEventFetchCartItems>((event, emit) async {
      print('----');
      print('CartEventFetchCartItems fired');
      print('----');
      try {
        emit(state.copyWith(states: CartStates.getting));
        final allUserCartItems = await cartHandler.fetchCartItems(event.userId);
        List<CartItem> cartItems = [];
        for (var cartItem in allUserCartItems) {
          if (cartItem.status == 'created') {
            cartItems.add(cartItem);
          }
        }
        emit(
          state.copyWith(
            cartItems: allUserCartItems,
            allUserCartItems: allUserCartItems,
            states: CartStates.got,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToGet);
        rethrow;
      }
    });

    on<CartEventAddCartItem>((event, emit) async {
      print('----');
      print('CartEventAddCartItem fired');
      print('----');
      try {
        emit(
          state.copyWith(
            cartItemToPush: event.cartItem,
            states: CartStates.adding,
          ),
        );
        await cartHandler.addCartItem(event.cartItem);
        emit(state.copyWith(states: CartStates.added));
      } catch (e) {
        emit(state.copyWith(states: CartStates.failedToAdd));
        rethrow;
      }
    });

    on<CartEventDeleteCartItem>((event, emit) async {
      print('----');
      print('CartEventDeleteCartItem fired');
      print('----');
      try {
        emit(state.copyWith(states: CartStates.deleting));
        await cartHandler.deleteCartItem(event.cartItem.id);
        final reducedListOfItmes = state.cartItems
            ?.where((item) => item.id != event.cartItem.id)
            .toList();
        final amount = await cartHandler.getUserCartItemAmount(event.userId);
        emit(
          state.copyWith(
            userCartItemAmount: amount,
            cartItems: reducedListOfItmes,
            states: CartStates.deleted,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToDelete);
        rethrow;
      }
    });

    on<CartEventDeleteCartItemById>((event, emit) async {
      print('----');
      print('CartEventDeleteCartItemById fired');
      print('----');
      try {
        emit(state.copyWith(states: CartStates.deleting));
        await cartHandler.deleteCartItem(event.cartItemId);
        final reducedListOfItmes = state.cartItems
            ?.where((item) => item.id != event.cartItemId)
            .toList();
        emit(
          state.copyWith(
            cartItems: reducedListOfItmes,
            states: CartStates.deleted,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToDelete);
        rethrow;
      }
    });

    on<CartEventUserCheckoutItems>((event, emit) async {
      print('----');
      print('CartEventUserCheckoutItems fired');
      print('----');
      try {
        await cartHandler.updateCartItem(event.checkoutItems, null);
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventStartCartItemsStream>((event, emit) {
      print('----');
      print('CartEventStartCartItemsStream fired');
      print('----');
      emit(state.copyWith(isStreaming: IsStreaming.yes));
      _streamSubscription?.cancel();
      _streamSubscription = cartHandler.cartItemsStream(event.userId).listen((
        streamedCartItems,
      ) {
        add(CartEventOnChangeStreamed(cartItems: streamedCartItems));
      });
    });

    on<CartEventOnChangeStreamed>((event, emit) {
      print('----');
      print('CartEventOnChangeStreamed fired');
      print('----');
      emit(
        state.copyWith(
          cartItems: event.cartItems,
          states: CartStates.streamEvent,
        ),
      );
    });

    on<CartEventCloseStream>((event, emit) {
      print('----');
      print('CartEventCloseStream fired');
      print('----');
      _streamSubscription?.cancel();
      emit(state.copyWith(isStreaming: IsStreaming.no));
    });

    on<CartEventFlushData>((event, emit) {
      print('----');
      print('CartEventFlushData fired');
      print('----');
      emit(
        state.copyWith(
          allUserCartItems: null,
          cartItemToPush: null,
          cartItems: null,
          cartItemsFromSignedOutUser: null,
          isStreaming: null,
          productCartItemAmount: null,
          userCartItemAmount: null,
          states: CartStates.empty,
        ),
      );
    });

    on<CartEventFetchUserCartItemAmount>((event, emit) async {
      print('----');
      print('CartEventFetchUserCartItemAmount fired');
      print('----');
      try {
        final userCartItemAmount = await cartHandler.getUserCartItemAmount(
          event.userId,
        );
        emit(
          state.copyWith(
            userCartItemAmount: userCartItemAmount,
            states: CartStates.fetchedUserCartItemCount,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: CartStates.faildToFetchUserCartItemCount));
        rethrow;
      }
    });

    on<CartEventFetchProductCartItemAmount>((event, emit) async {
      print('----');
      print('CartEventFetchProductCartItemAmount fired');
      print('----');
      try {
        final productCartItemAmount = await cartHandler
            .getProductCartItemAmount(event.userId, event.productId);
        emit(
          state.copyWith(
            productCartItemAmount: productCartItemAmount,
            states: CartStates.fetchedProductCartItemCount,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(states: CartStates.faildFetchedProductCartItemCount),
        );
        rethrow;
      }
    });

    on<CartEventDeleteLastAddedProductCartItem>((event, emit) async {
      print('----');
      print('CartEventDeleteLastAddedProductCartItem fired');
      print('----');
      try {
        final didDelete = await cartHandler.deletedLastAddedProductCartItem(
          event.userId,
          event.productId,
        );
        if (didDelete) {
          emit(
            state.copyWith(states: CartStates.deletedLastAddedProductCartItem),
          );
        } else {
          emit(
            state.copyWith(
              states: CartStates.failedToDeleteLastAddedProductCartItem,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            states: CartStates.failedToDeleteLastAddedProductCartItem,
          ),
        );
        rethrow;
      }
    });
  }
}
