import 'dart:async';

import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/custom_ui_elements/dialogs/on_unauth_buy_to_register.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/driver/cart_page_cubit.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/material_cart_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CartPageDriver extends StatefulWidget {
  const CartPageDriver({super.key});

  @override
  State<CartPageDriver> createState() => _CartPageDriverState();
}

class _CartPageDriverState extends State<CartPageDriver>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final CartPageCubit _cartPageCubit;
  Completer<void>? _refreshCompleter;

  @override
  void initState() {
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    _cartPageCubit = CartPageCubit(
      cartBloc: context.read<CartBloc>(),
      products: context.read<DatabaseBloc>().state.products ?? [],
      appLifecycleService: getIt<AppLifecycleService>(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _cartPageCubit.close();
    super.dispose();
  }

  void _onACartItemDelete({
    required BuildContext context,
    required CartItem cartItem,
  }) {
    context.read<CartBloc>().add(
      CartEventDeleteCartItem(
        cartItem: cartItem,
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    context.read<CartPageCubit>().setDeletingItem(cartItem);
  }

  void _onBuyPressed(BuildContext context) async {
    if (_cartPageCubit.state.totalPrice != 0 ||
        (_cartPageCubit.state.cartItemsTuBuy?.isNotEmpty ?? false)) {
      if (context.read<AuthBloc>().state.currentUser.isAnonymous) {
        final didRegistered = await showOnUnauthBuyToRegister(context);
        if ((didRegistered ?? false) && context.mounted) {
          context.read<PaymentBloc>().add(
            PaymentEventPay(
              provider: 'YooPay',
              cartItems: _cartPageCubit.state.cartItemsTuBuy!,
            ),
          );
          // _cartPageCubit.flushCartItems();
        }
        Fluttertoast.showToast(msg: 'You must register to buy');
        return;
      } else {
        context.read<PaymentBloc>().add(
          PaymentEventPay(
            provider: 'YooPay',
            cartItems: _cartPageCubit.state.cartItemsTuBuy!,
          ),
        );
        // _cartPageCubit.flushCartItems();
      }
    }
  }

  void _onShowBottonSheet(BuildContext context) {
    context.push(AppRoutes.itemsOnPaymentSheet.path);
  }

  Future<void> _reFresher(BuildContext context) async {
    _refreshCompleter = Completer();
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    context.read<CartBloc>().add(
      CartEventStartStreamPendingOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    context.read<CartBloc>().add(
      CartEventStartStreamUserCartItemAmount(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    await _refreshCompleter!.future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.states == CartStates.loading &&
          current.states != CartStates.loading,
      listener: (context, state) {
        if (!(_refreshCompleter?.isCompleted ?? true)) {
          _refreshCompleter!.complete();
        }
      },
      child: BlocProvider.value(
        value: _cartPageCubit,
        child: Builder(
          builder: (context) {
            return MaterialCartPageView(
              onACartItemDelete: (toDelete) =>
                  _onACartItemDelete(cartItem: toDelete, context: context),
              onBuyPressed: () => _onBuyPressed(context),
              onShowBottonSheet: () => _onShowBottonSheet(context),
              reFresher: () => _reFresher(context),
            );
          },
        ),
      ),
    );
  }
}
