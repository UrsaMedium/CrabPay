import 'dart:async';

import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/views/main_screen/_sub/orders_view/driver/crab_order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrdersViewState {
  final int page;
  final bool isSyncingPages;
  final bool isLoadingMore;
  final bool hasMoreNotDeliveredOrders;
  final bool hasMoreDeliveredOrders;
  final bool hasMoreSearchedOrders;
  final List<CrabOrder>? crabNotDeliveredOrders;
  final List<CrabOrder>? crabDeliveredOrders;
  final List<CrabOrder>? crabSearchedOrders;
  final bool isSerchOpen;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool isSupportMessageSending;

  OrdersViewState({
    this.isLoadingMore = false,
    this.hasMoreNotDeliveredOrders = true,
    this.crabNotDeliveredOrders,
    this.page = 0,
    this.hasMoreDeliveredOrders = true,
    this.crabDeliveredOrders,
    this.isSyncingPages = false,
    this.isSerchOpen = false,
    this.hasMoreSearchedOrders = true,
    this.crabSearchedOrders,
    this.fromDate,
    this.toDate,
    this.isSupportMessageSending = false,
  });

  OrdersViewState copyWith({
    int? page,
    bool? isLoadingMore,
    bool? hasMoreNotDeliveredOrders,
    List<CrabOrder>? crabNotDeliveredOrders,
    bool? hasMoreDeliveredOrders,
    List<CrabOrder>? crabDeliveredOrders,
    bool? isSyncingPages,
    bool? isSerchOpen,
    bool? hasMoreSearchedOrders,
    List<CrabOrder>? crabSearchedOrders,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isSupportMessageSending,
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
      isSyncingPages: isSyncingPages ?? this.isSyncingPages,
      isSerchOpen: isSerchOpen ?? this.isSerchOpen,
      hasMoreSearchedOrders:
          hasMoreSearchedOrders ?? this.hasMoreSearchedOrders,
      crabSearchedOrders: crabSearchedOrders ?? this.crabSearchedOrders,
      fromDate: fromDate == null
          ? this.fromDate
          : fromDate == DateTime(0)
          ? null
          : fromDate,
      toDate: toDate == null
          ? this.toDate
          : toDate == DateTime(0)
          ? null
          : toDate,
      isSupportMessageSending:
          isSupportMessageSending ?? this.isSupportMessageSending,
    );
  }
}

class OrdersViewCubit extends Cubit<OrdersViewState> {
  final CartBloc _cartBloc;
  final ChatBloc _chatBloc;
  final List<Product> _products;
  late final StreamSubscription _cartSubscription;
  late final StreamSubscription _chatSubscription;
  OrdersViewCubit({
    required CartBloc cartBloc,
    required ChatBloc chatBloc,
    required List<Product> products,
  }) : _products = products,
       _cartBloc = cartBloc,
       _chatBloc = chatBloc,
       super(OrdersViewState()) {
    _syncDataForNotDeliveredOrders(_cartBloc.state);
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      if (cartState.states == CartStates.loadedMoreOrdersNotDeliveredOrders) {
        _syncDataForNotDeliveredOrders(cartState);
      }
      if (cartState.states == CartStates.loadedMoreOrdersDeliveredOrders) {
        _syncDataForDeliveredOrders(cartState);
      }
      if (cartState.states == CartStates.searchedOrders) {
        _syncSearchedOrders(cartState);
      }
    });
    _chatSubscription = _chatBloc.stream.listen((chatState) {
      if (chatState.status == ChatStates.shadowMessageSent) {
        Fluttertoast.showToast(msg: 'sent');
        emit(state.copyWith(isSupportMessageSending: false));
      } else if (chatState.status == ChatStates.shadowMessageSentFailed) {
        Fluttertoast.showToast(msg: 'failed');
        emit(state.copyWith(isSupportMessageSending: false));
      }
    });
  }

  void _syncDataForNotDeliveredOrders(CartState cartState) {
    _setHasMoreNotDeliveredOrders(
      cartState.notDeliveredOrders?.hasMore ?? true,
    );
    _setNotDeliveredOrderGroups(
      crabNotDeliveredOrders: cartState.itemsOfNotDeliveredOrders ?? {},
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
      crabDeliveredOrders: cartState.itemsOfDeliveredOrders ?? {},
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

  void _syncSearchedOrders(CartState cartState) {
    _setHasMoreSearchedOrders(cartState.searchedOrders?.hasMore ?? true);
    _setSearchedOrderGroups(
      crabSearchedOrders: cartState.itemsOfSearchedOrders ?? {},
    );
    setLoadingState(false);
  }

  void _setHasMoreSearchedOrders(bool hasMoreSearchedOrders) {
    emit(state.copyWith(hasMoreSearchedOrders: hasMoreSearchedOrders));
  }

  void _setSearchedOrderGroups({
    required Map<String, List<CartItem>> crabSearchedOrders,
  }) {
    List<CrabOrder> result = [];
    for (var orderEntry in crabSearchedOrders.entries) {
      result.add(
        CrabOrder.fromOrderEntry(orderEntry: orderEntry, products: _products),
      );
    }
    emit(state.copyWith(crabSearchedOrders: result));
  }

  void setSearchingState(bool isSerchOpen) {
    emit(state.copyWith(isSerchOpen: isSerchOpen));
    setSearchFilterParameters(null, null);
  }

  void setSearchFilterParameters(DateTime? fromDate, DateTime? toDate) {
    emit(
      state.copyWith(
        fromDate: fromDate ?? DateTime(0),
        toDate: toDate ?? DateTime(0),
      ),
    );
  }

  void setSyncingState(bool isSyncingPages) {
    emit(state.copyWith(isSyncingPages: isSyncingPages));
  }

  void setLoadingState(bool isLoading) {
    emit(state.copyWith(isLoadingMore: isLoading));
  }

  void setPage(int index) {
    emit(state.copyWith(page: index));
  }

  void setSupportMessageStateTrue() {
    emit(state.copyWith(isSupportMessageSending: true));
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    _chatSubscription.cancel();
    return super.close();
  }
}
