import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/inner_cart_handler.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(InnerCartHandler cartHandler) : super(const CartState()) {
    on<CartEventAddCartItem>((event, emit) async {
      try {
        await cartHandler.addCartItem(event.cartItem);
        emit(
          state.copyWith(
            cartItemToPush: event.cartItem,
            states: CartStates.adding,
          ),
        );
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventFetchCartItems>((event, emit) async {
      try {
        final cartItems = await cartHandler.fetchCartItems(event.userId);
        emit(state.copyWith(cartItems: cartItems, states: CartStates.getting));
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventDeleteCartItem>((event, emit) async {
      try {
        print(event.cartItem.id);
        await cartHandler.deleteCartItem(event.cartItem.id);

        emit(state.copyWith(states: CartStates.deleting));
      } catch (e) {
        rethrow;
      }
    });
  }
}
