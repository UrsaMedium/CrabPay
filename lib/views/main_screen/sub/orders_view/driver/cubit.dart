import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersViewState {
  final int page;
  final bool isLoadingMore;
  final bool hasMore;
  final List<CrabOrder>? crabOrders;

  OrdersViewState({
    this.isLoadingMore = false,
    this.hasMore = true,
    this.crabOrders,
    this.page = 0,
  });

  OrdersViewState copyWith({
    int? page,
    bool? isLoadingMore,
    bool? hasMore,
    List<CrabOrder>? crabOrders,
  }) {
    return OrdersViewState(
      page: page ?? this.page,
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
  OrdersViewCubit({required CartBloc cartBloc, required List<Product> products})
    : _products = products,
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
    _setHasMore(cartState.notDeliveredOrders?.hasMore ?? true);
    _setOrderGroups(orderGroups: cartState.itemsOfNotDeliveredOrder ?? {});
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

  void setPage(int index) {
    emit(state.copyWith(page: index));
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
