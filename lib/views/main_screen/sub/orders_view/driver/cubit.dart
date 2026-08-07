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
  final bool hasMoreNotDeliveredOrders;
  final bool hasMoreDeliveredOrders;
  final List<CrabOrder>? crabNotDeliveredOrders;
  final List<CrabOrder>? crabDeliveredOrders;

  OrdersViewState({
    this.isLoadingMore = false,
    this.hasMoreNotDeliveredOrders = true,
    this.crabNotDeliveredOrders,
    this.page = 0,
    this.hasMoreDeliveredOrders = true,
    this.crabDeliveredOrders,
  });

  OrdersViewState copyWith({
    int? page,
    bool? isLoadingMore,
    bool? hasMoreNotDeliveredOrders,
    List<CrabOrder>? crabNotDeliveredOrders,
    bool? hasMoreDeliveredOrders,
    List<CrabOrder>? crabDeliveredOrders,
  }) {
    return OrdersViewState(
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreNotDeliveredOrders:
          hasMoreNotDeliveredOrders ?? this.hasMoreNotDeliveredOrders,
      crabNotDeliveredOrders:
          crabNotDeliveredOrders ?? this.crabNotDeliveredOrders,
      crabDeliveredOrders: crabDeliveredOrders ?? this.crabDeliveredOrders,
      hasMoreDeliveredOrders:
          hasMoreDeliveredOrders ?? this.hasMoreDeliveredOrders,
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
    _syncDataForNotDeliveredOrders(_cartBloc.state);
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      if (cartState.states == CartStates.loadedMoreOrdersNotDeliveredOrders) {
        _syncDataForNotDeliveredOrders(cartState);
      }
      if (cartState.states == CartStates.loadedMoreOrdersDeliveredOrders) {
        _syncDataForDeliveredOrders(cartState);
      }
    });
  }

  void _syncDataForNotDeliveredOrders(CartState cartState) {
    _setHasMoreNotDeliveredOrders(
      cartState.notDeliveredOrders?.hasMore ?? true,
    );
    _setNotDeliveredOrderGroups(
      crabNotDeliveredOrders: cartState.itemsOfNotDeliveredOrder ?? {},
    );
    setLoadingState(false);
  }

  void _setHasMoreNotDeliveredOrders(bool hasMoreNotDeliveredOrders) {
    emit(state.copyWith(hasMoreNotDeliveredOrders: hasMoreNotDeliveredOrders));
  }

  void _setNotDeliveredOrderGroups({
    required Map<String, List<CartItem>> crabNotDeliveredOrders,
  }) {
    List<CrabOrder> result = [];
    for (var orderEntry in crabNotDeliveredOrders.entries) {
      result.add(
        CrabOrder.fromOrderEntry(orderEntry: orderEntry, products: _products),
      );
    }
    emit(state.copyWith(crabNotDeliveredOrders: result));
  }

  void _syncDataForDeliveredOrders(CartState cartState) {
    _setHasMoreDeliveredOrders(cartState.deliveredOrders?.hasMore ?? true);
    _setDeliveredOrderGroups(
      crabDeliveredOrders: cartState.itemsOfDeliveredOrder ?? {},
    );
    setLoadingState(false);
  }

  void _setHasMoreDeliveredOrders(bool hasMoreDeliveredOrders) {
    emit(state.copyWith(hasMoreDeliveredOrders: hasMoreDeliveredOrders));
  }

  void _setDeliveredOrderGroups({
    required Map<String, List<CartItem>> crabDeliveredOrders,
  }) {
    List<CrabOrder> result = [];
    for (var orderEntry in crabDeliveredOrders.entries) {
      result.add(
        CrabOrder.fromOrderEntry(orderEntry: orderEntry, products: _products),
      );
    }
    emit(state.copyWith(crabDeliveredOrders: result));
  }

  void setLoadingState(bool isLoading) {
    emit(state.copyWith(isLoadingMore: isLoading));
  }

  void setPage(int index) {
    emit(state.copyWith(page: index));
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    return super.close();
  }
}
