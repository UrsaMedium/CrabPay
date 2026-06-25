import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/inner_cart_handler.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  StreamSubscription? _streamSubscription;
  CartBloc(InnerCartHandler cartHandler) : super(const CartState()) {
    on<CartEventFetchCartItems>((event, emit) async {
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
      try {
        emit(state.copyWith(states: CartStates.deleting));
        await cartHandler.deleteCartItem(event.cartItem.id);
        final reducedListOfItmes = state.cartItems
            ?.where((item) => item.id != event.cartItem.id)
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
      try {
        await cartHandler.updateCartItem(event.checkoutItems, null);
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventStartCartItemsStream>((event, emit) {
      emit(state.copyWith(isStreaming: IsStreaming.yes));
      _streamSubscription?.cancel();
      _streamSubscription = cartHandler.cartItemsStream(event.userId).listen((
        streamedCartItems,
      ) {
        add(CartEventOnChangeStreamed(cartItems: streamedCartItems));
      });
    });

    on<CartEventOnChangeStreamed>((event, emit) {
      emit(
        state.copyWith(
          cartItems: event.cartItems,
          states: CartStates.streamEvent,
        ),
      );
    });

    on<CartEventCloseStream>((event, emit) {
      _streamSubscription?.cancel();
      emit(state.copyWith(isStreaming: IsStreaming.no));
    });

    on<CartEventFlushData>((event, emit) => emit(state.flushData()));
  }
}
