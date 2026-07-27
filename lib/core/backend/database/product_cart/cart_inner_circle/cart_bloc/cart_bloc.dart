import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  StreamSubscription? _streamSubscription;
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  late final AppLifecycleListener _lifecycleListener;
  String? _activeUserId;

  CartBloc({
    required InnerCartHandler cartHandler,
    required AuthInnerInterface authInterface,
  }) : _authInterface = authInterface,
       super(const CartState()) {
    _lifecycleListener = AppLifecycleListener(
      onResume: _onAppResumeFromBackground,
    );

    on<CartEventFetchCartItems>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchCartItems fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final allUserCartItems = await cartHandler.fetchCartItems(event.userId);
        List<CartItem> cartItemsToBuy = [];
        List<CartItem> cartItemsProccessed = [];
        for (var cartItem in allUserCartItems) {
          if (cartItem.status == 'created' || cartItem.status == 'failed') {
            cartItemsToBuy.add(cartItem);
          } else {
            cartItemsProccessed.add(cartItem);
          }
        }
        emit(
          state.copyWith(
            cartItemsToBuy: cartItemsToBuy,
            allUserCartItems: allUserCartItems,
            cartItemsProccessed: cartItemsProccessed,
            states: CartStates.got,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToGet);
        rethrow;
      }
    });

    on<CartEventAddCartItem>((event, emit) async {
      developer.log('----');
      developer.log('CartEventAddCartItem fired');
      developer.log('----');
      try {
        emit(
          state.copyWith(
            cartItemToPush: event.cartItem,
            states: CartStates.loading,
          ),
        );
        await cartHandler.addCartItem(event.cartItem);
        final updatedProductAmount = await cartHandler.getProductCartItemAmount(
          event.userId,
          event.cartItem.productId,
        );
        // final updatedUserAmount = await cartHandler.getUserCartItemAmount(
        //   event.userId,
        // );
        // final updatedCartItems = await cartHandler.fetchCartItems(event.userId);
        emit(
          state.copyWith(
            // cartItems: updatedCartItems,
            // allUserCartItems: updatedCartItems,
            productCartItemAmount: updatedProductAmount,
            // userCartItemAmount: updatedUserAmount,
            states: CartStates.added,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: CartStates.failedToAdd));
        rethrow;
      }
    });

    on<CartEventDeleteCartItem>((event, emit) async {
      developer.log('----');
      developer.log('CartEventDeleteCartItem fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        await cartHandler.deleteCartItem(event.cartItem.id);
        final reducedListOfItmes = state.cartItemsToBuy
            ?.where((item) => item.id != event.cartItem.id)
            .toList();
        emit(
          state.copyWith(
            cartItemsToBuy: reducedListOfItmes,
            states: CartStates.deleted,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToDelete);
        rethrow;
      }
    });

    on<CartEventDeleteCartItemById>((event, emit) async {
      developer.log('----');
      developer.log('CartEventDeleteCartItemById fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        await cartHandler.deleteCartItem(event.cartItemId);
        final reducedListOfItmes = state.cartItemsToBuy
            ?.where((item) => item.id != event.cartItemId)
            .toList();
        emit(
          state.copyWith(
            cartItemsToBuy: reducedListOfItmes,
            states: CartStates.deleted,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToDelete);
        rethrow;
      }
    });

    on<CartEventUserCheckoutItems>((event, emit) async {
      developer.log('----');
      developer.log('CartEventUserCheckoutItems fired');
      developer.log('----');
      try {
        await cartHandler.updateCartItem(event.checkoutItems, null);
      } catch (e) {
        rethrow;
      }
    });

    // on<CartEventStartCartItemsStream>((event, emit) {
    //   developer.log('----');
    //   developer.log('CartEventStartCartItemsStream fired');
    //   developer.log('----');
    //   emit(state.copyWith(isStreaming: IsStreaming.yes));
    //   _streamSubscription?.cancel();
    //   _streamSubscription = cartHandler.cartItemsStream(event.userId).listen((
    //     streamedCartItems,
    //   ) {
    //     add(CartEventOnChangeStreamed(cartItems: streamedCartItems));
    //   }, onError: (error) => debugPrint(error));
    // });

    // on<CartEventOnChangeStreamed>((event, emit) async {
    //   developer.log('----');
    //   developer.log('CartEventOnChangeStreamed fired');
    //   developer.log('----');

    //   emit(
    //     state.copyWith(
    //       cartItemsToBuy: event.cartItems,
    //       states: CartStates.streamEvent,
    //     ),
    //   );
    // });

    on<CartEventStartStreamUserCartItemAmount>((event, emit) async {
      if (_activeUserId == event.userId && _streamSubscription != null) {
        return;
      }

      await _streamSubscription?.cancel();
      _activeUserId = event.userId;

      _streamSubscription = cartHandler
          .streamUserCartItemAmount(event.userId)
          .listen(
            (count) {
              add(CartEventUpdateUserCartItemAmountFromStream(amount: count));
            },
            onError: (error, stackTrace) {
              _activeUserId = null;
            },
            onDone: () {
              _activeUserId = null;
            },
          );
    });

    on<CartEventUpdateUserCartItemAmountFromStream>((event, emit) {
      developer.log('----');
      developer.log('CartEventUpdateUserCartItemAmountFromStream fired');
      developer.log('----');
      emit(
        state.copyWith(
          isStreaming: IsStreaming.yes,
          userCartItemAmount: event.amount,
        ),
      );
    });

    // on<CartEventCloseStream>((event, emit) {
    //   developer.log('----');
    //   developer.log('CartEventCloseStream fired');
    //   developer.log('----');
    //   _streamSubscription?.cancel();
    //   emit(state.copyWith(isStreaming: IsStreaming.no));
    // });

    on<CartEventFlushData>((event, emit) {
      developer.log('----');
      developer.log('CartEventFlushData fired');
      developer.log('----');
      emit(
        state.copyWith(
          allUserCartItems: null,
          cartItemToPush: null,
          cartItemsToBuy: null,
          cartItemsFromSignedOutUser: null,
          isStreaming: null,
          productCartItemAmount: null,
          userCartItemAmount: null,
          states: CartStates.empty,
        ),
      );
    });

    on<CartEventFetchProductCartItemAmount>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchProductCartItemAmount fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
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
      developer.log('----');
      developer.log('CartEventDeleteLastAddedProductCartItem fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final didDelete = await cartHandler.deleteLastAddedProductCartItem(
          event.userId,
          event.productId,
        );
        if (didDelete) {
          final updatedProductAmount = await cartHandler
              .getProductCartItemAmount(event.userId, event.productId);
          // final updatedUserAmount = await cartHandler.getUserCartItemAmount(
          //   event.userId,
          // );
          // final updatedCartItems = await cartHandler.fetchCartItems(
          //   event.userId,
          // );
          emit(
            state.copyWith(
              // cartItems: updatedCartItems,
              // allUserCartItems: updatedCartItems,
              productCartItemAmount: updatedProductAmount,
              // userCartItemAmount: updatedUserAmount,
              states: CartStates.deletedLastAddedProductCartItem,
            ),
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

    _authSubscription = _authInterface.userStream.listen((user) {
      final isAccountChange = _activeUserId != user.id;
      _activeUserId = user.id;

      if (isAccountChange) {
        add(CartEventFlushData());
        add(CartEventFetchCartItems(userId: user.id));
      }

      if (user.id.isNotEmpty) {
        add(CartEventStartStreamUserCartItemAmount(userId: user.id));
      }
    });
  }
  void _onAppResumeFromBackground() {
    final session = Supabase.instance.client.auth.currentSession;
    final userId = session?.user.id;

    if (userId != null && userId.isNotEmpty && !session!.isExpired) {
      Supabase.instance.client.removeAllChannels();

      _activeUserId = null;
      add(CartEventStartStreamUserCartItemAmount(userId: userId));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _streamSubscription?.cancel();
    _lifecycleListener.dispose();
    return super.close();
  }
}
