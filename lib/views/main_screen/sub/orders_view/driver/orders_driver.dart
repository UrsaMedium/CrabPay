import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/material_orders_view.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OrdersViewDriver extends StatefulWidget {
  const OrdersViewDriver({super.key});

  @override
  State<OrdersViewDriver> createState() => _OrdersViewDriverState();
}

class _OrdersViewDriverState extends State<OrdersViewDriver> {
  late final OrdersViewCubit _ordersViewCubit;
  late final List<Product> _products;

  @override
  void initState() {
    _products = context.read<DatabaseBloc>().state.products ?? [];
    _ordersViewCubit = OrdersViewCubit(
      cartBloc: context.read<CartBloc>(),
      products: _products,
    );
    context.read<CartBloc>().add(CartEventFlushOrders());
    context.read<CartBloc>().add(
      CartEventFetchOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context.read<CartBloc>().state.orders?.nextPageToken,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _ordersViewCubit.close();
    super.dispose();
  }

  void _onLoadMore(BuildContext context) {
    _ordersViewCubit.setLoadingState(true);
    context.read<CartBloc>().add(
      CartEventFetchOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context.read<CartBloc>().state.orders?.nextPageToken,
      ),
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'CasesViewDriver _onBackButtonPressed',
    );
    context.read<CartBloc>().add(CartEventFlushOrders());
    if (context.canPop()) {
      context.pop();
    }
  }

  void _onSupportSendMessagePressed(String orderId) {
    context.goNamed(
      AppRoutes.support.name,
      queryParameters: {'orderId': orderId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        getIt<InnerLoggerHandler>().logBreadcrumb(
          message: 'LoginViewDriver onPopInvokedWithResult',
          data: {'didPop': didPop, 'result': result},
        );
        if (didPop) {
          return;
        }
        !Navigator.of(context).canPop()
            ? context.go(AppRoutes.home.path)
            : context.pop();
      },
      child: BlocProvider.value(
        value: _ordersViewCubit,
        child: Builder(
          builder: (context) {
            //
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              // return CupertinoOrdersView();
            }

            return MaterialOrdersView(
              onLoadMore: () => _onLoadMore(context),
              onBackButtonPressed: () => _onBackButtonPressed(context),
              onSupportSendMessagePressed: _onSupportSendMessagePressed,
            );
          },
        ),
      ),
    );
  }
}
