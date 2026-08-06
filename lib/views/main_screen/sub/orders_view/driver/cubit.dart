import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersViewState {
  final bool isLoadingMore;
  final bool hasMore;
  final List<CrabOrder>? crabOrders;

  OrdersViewState({
    this.isLoadingMore = false,
    this.hasMore = true,
    this.crabOrders,
  });

  OrdersViewState copyWith({
    bool? isLoadingMore,
    bool? hasMore,
    List<CrabOrder>? crabOrders,
  }) {
    return OrdersViewState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      crabOrders: crabOrders ?? this.crabOrders,
    );
  }
}

class OrdersViewCubit extends Cubit<OrdersViewState> {
  final CartBloc _cartBloc;
  final List<Product> _products;
  late final StreamSubscription _cartSubscription;
  OrdersViewCubit({
    required CartBloc cartBloc,
    required List<Product> products,
  }) : _products = products,
       _cartBloc = cartBloc,
       super(OrdersViewState()) {
    _syncData(_cartBloc.state);
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      if (cartState.states == CartStates.loadedMoreOrders) {
        _syncData(cartState);
      }
    });
  }

  void _syncData(CartState cartState) {
    setLoadingState(false);
    _setHasMore(cartState.orders?.hasMore ?? true);
    _setOrderGroups(orderGroups: cartState.itemsOfOrder ?? {});
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    return super.close();
  }

  void setLoadingState(bool isLoading) {
    emit(state.copyWith(isLoadingMore: isLoading));
  }

  void _setHasMore(bool hasMore) {
    emit(state.copyWith(hasMore: hasMore));
  }

  void _setOrderGroups({required Map<String, List<CartItem>> orderGroups}) {
    List<CrabOrder> result = [];
    for (var orderEntry in orderGroups.entries) {
      result.add(
        CrabOrder.fromOrderEntry(orderEntry: orderEntry, products: _products),
      );
    }
    emit(state.copyWith(crabOrders: result));
  }
}
