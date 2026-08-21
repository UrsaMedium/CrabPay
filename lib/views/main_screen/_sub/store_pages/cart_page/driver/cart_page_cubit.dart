import 'dart:async';

import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class CartPageState extends Equatable {
  final List<CartItem>? cartItemsTuBuy;
  final List<PendingOrder>? pendingOrder;
  final CartItem? itemToDelete;
  final List<Product> products;
  final double? totalPrice;

  const CartPageState({
    this.itemToDelete,
    this.cartItemsTuBuy,
    required this.products,
    this.totalPrice,
    this.pendingOrder,
  });

  CartPageState copyWith({
    CartItem? itemToDelete,
    List<CartItem>? cartItemsTuBuy,
    List<Product>? products,
    List<PendingOrder>? pendingOrder,
    double? totalPrice,
  }) => CartPageState(
    itemToDelete: itemToDelete ?? this.itemToDelete,
    cartItemsTuBuy: cartItemsTuBuy ?? this.cartItemsTuBuy,
    pendingOrder: pendingOrder ?? this.pendingOrder,
    products: products ?? this.products,
    totalPrice: totalPrice ?? this.totalPrice,
  );

  @override
  List<Object?> get props => [
    itemToDelete,
    totalPrice,
    cartItemsTuBuy,
    pendingOrder,
    products,
  ];
}

class CartPageCubit extends Cubit<CartPageState> {
  final CartBloc _cartBloc;
  final AppLifecycleService _appLifecycleService;
  late final StreamSubscription _cartSubscription;
  late final StreamSubscription _appLifecycleSub;
  CartPageCubit({
    required CartBloc cartBloc,
    required List<Product> products,
    required AppLifecycleService appLifecycleService,
  }) : _cartBloc = cartBloc,
       _appLifecycleService = appLifecycleService,
       super(CartPageState(products: products)) {
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      _cartSync(cartState);
    });
    _appLifecycleSub = _appLifecycleService.appStateStream.listen((appState) {
      if (appState == AppState.paused) {
        _cartSubscription.pause();
      }
      if (appState == AppState.active) {
        _cartSync(cartBloc.state);
        _cartSubscription.resume();
      }
    });
  }

  void _cartSync(CartState cartState) {
    emit(
      state.copyWith(
        cartItemsTuBuy: cartState.cartItemsToBuy ?? [],
        pendingOrder: cartState.pendingOrders ?? [],
      ),
    );
    _countTotal();
  }

  void _countTotal() {
    final total =
        state.cartItemsTuBuy?.fold(
          .0,
          (sum, item) => sum + item.checkoutPrice,
        ) ??
        0;
    emit(state.copyWith(totalPrice: total));
  }

  void setDeletingItem(CartItem? itemToDelete) =>
      emit(state.copyWith(itemToDelete: itemToDelete));

  void flushCartItems() {
    emit(state.copyWith(cartItemsTuBuy: []));
  }

  @override
  Future<void> close() {
    _cartSubscription.cancel();
    _appLifecycleSub.cancel();
    return super.close();
  }
}
