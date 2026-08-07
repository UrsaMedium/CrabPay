import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/common/paginated_result_data_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  StreamSubscription? _userCartItemAmountSub;
  String? _activeUserId;

  CartBloc({
    required InnerCartHandler cartHandler,
    required AuthInnerInterface authInterface,
  }) : _authInterface = authInterface,
       super(const CartState()) {
    //streaming---------------------------------------------------------------------------------

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

    on<CartEventStartStreamUserCartItemAmount>((event, emit) async {
      if (_activeUserId == event.userId && _userCartItemAmountSub != null) {
        return;
      }

      await _userCartItemAmountSub?.cancel();
      _activeUserId = event.userId;
      _userCartItemAmountSub = cartHandler
          .streamUserCartItemAmount(_activeUserId!)
          .listen((userCartItemAmount) {
            add(
              CartEventUpdateUserCartItemAmountFromStream(
                amount: userCartItemAmount,
              ),
            );
          });
    });

    on<CartEventUpdateUserCartItemAmountFromStream>((event, emit) {
      developer.log('----');
      developer.log('CartEventUpdateUserCartItemAmountFromStream fired');
      developer.log('----');
      emit(
        state.copyWith(
          isCartStreaming: IsCartStreaming.yes,
          userCartItemAmount: event.amount,
        ),
      );
    });
    //streaming---------------------------------------------------------------------------------

    on<CartEventFetchCartItems>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchCartItems fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final cartItemsToBuy = await cartHandler.fetchCartItemsToBuy(
          event.userId,
        );

        emit(
          state.copyWith(
            cartItemsToBuy: cartItemsToBuy,
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

    on<CartEventFetchNotDeliveredOrders>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchNotDeliveredOrders fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final fetchedOrders = await cartHandler.fetchNotDeliveredOrdersIds(
          event.userId,
          pageToken: event.pageToken,
        );
        List<String> oldOrdersList = state.notDeliveredOrders?.objects ?? [];
        List<String> newOrdersList = [
          ...oldOrdersList,
          ...fetchedOrders.objects,
        ];

        var mapOfOrders = state.itemsOfNotDeliveredOrder ?? {};
        for (final order in fetchedOrders.objects) {
          final itemsOfOrder = await cartHandler.fetchItemsOfOrder(
            event.userId,
            order,
          );
          mapOfOrders[order] = itemsOfOrder;
        }

        emit(
          state.copyWith(
            states: CartStates.loadedMoreOrdersNotDeliveredOrders,
            itemsOfNotDeliveredOrder: mapOfOrders,
            notDeliveredOrders: PaginatedResult(
              objects: newOrdersList,
              hasMore: fetchedOrders.hasMore,
              nextPageToken: fetchedOrders.nextPageToken,
            ),
          ),
        );
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventFetchDeliveredOrders>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchDeliveredOrders fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final fetchedOrders = await cartHandler.fetchDeliveredOrdersIds(
          event.userId,
          pageToken: event.pageToken,
        );
        List<String> oldOrdersList = state.deliveredOrders?.objects ?? [];
        List<String> newOrdersList = [
          ...oldOrdersList,
          ...fetchedOrders.objects,
        ];

        var mapOfOrders = state.itemsOfDeliveredOrder ?? {};
        for (final order in fetchedOrders.objects) {
          final itemsOfOrder = await cartHandler.fetchItemsOfOrder(
            event.userId,
            order,
          );
          mapOfOrders[order] = itemsOfOrder;
        }

        emit(
          state.copyWith(
            states: CartStates.loadedMoreOrdersDeliveredOrders,
            itemsOfDeliveredOrder: mapOfOrders,
            deliveredOrders: PaginatedResult(
              objects: newOrdersList,
              hasMore: fetchedOrders.hasMore,
              nextPageToken: fetchedOrders.nextPageToken,
            ),
          ),
        );
      } catch (e) {
        rethrow;
      }
    });

    on<CartEventFetchCartItemsOnPaymentState>((event, emit) async {
      developer.log('----');
      developer.log('CartEventFetchCartItemsOnPaymentState fired');
      developer.log('----');
      try {
        emit(state.copyWith(states: CartStates.loading));
        final cartItemsOnPaymentState = await cartHandler
            .fetchCartItemsOnPyamentState(event.userId);

        emit(
          state.copyWith(
            cartItemsOnPaymentState: cartItemsOnPaymentState,
            states: CartStates.got,
          ),
        );
      } catch (e) {
        state.copyWith(states: CartStates.failedToGet);
        rethrow;
      }
    });

    on<CartEventFlushData>((event, emit) {
      developer.log('----');
      developer.log('CartEventFlushData fired');
      developer.log('----');
      emit(
        state.copyWith(
          cartItemToPush: null,
          cartItemsToBuy: null,
          itemsOfNotDeliveredOrder: null,
          notDeliveredOrders: null,
          cartItemsFromSignedOutUser: null,
          productCartItemAmount: null,
          userCartItemAmount: null,
          isCartStreaming: IsCartStreaming.no,
          states: CartStates.empty,
        ),
      );
    });

    on<CartEventFlushOrders>((event, emit) {
      developer.log('----');
      developer.log('CartEventFlushOrders fired');
      developer.log('----');
      emit(
        state.copyWith(
          notDeliveredOrders: null,
          itemsOfNotDeliveredOrder: null,
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
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _userCartItemAmountSub?.cancel();
    return super.close();
  }
}
