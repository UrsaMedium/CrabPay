import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/search/custom_syncfusion_date_range_dialog.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/delivery_pages/material_delivered_orders_page.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/delivery_pages/material_not_delivered_orders_page.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/main_orders_view/material_orders_view.dart';
import 'package:crabpay/core/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material/search/material_searched_orders_page.dart';
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
  late final PageController _pageController;

  @override
  void initState() {
    _products = context.read<DatabaseBloc>().state.products ?? [];
    _ordersViewCubit = OrdersViewCubit(
      cartBloc: context.read<CartBloc>(),
      products: _products,
    );
    context.read<CartBloc>().add(CartEventFlushOrders());
    context.read<CartBloc>().add(
      CartEventFetchNotDeliveredOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context
            .read<CartBloc>()
            .state
            .notDeliveredOrders
            ?.nextPageToken,
      ),
    );
    context.read<CartBloc>().add(
      CartEventFetchDeliveredOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context
            .read<CartBloc>()
            .state
            .deliveredOrders
            ?.nextPageToken,
      ),
    );
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _ordersViewCubit.close();
    super.dispose();
  }

  Widget _pageBuilder({required BuildContext context, required int index}) {
    Widget result;
    if (index == 0) {
      result = MaterialNotDeliveredOrdersPage(
        onLoadMoreNotDeliveredOrders: () =>
            _onLoadMoreNotDeliveredOrders(context),
        onSupportSendMessagePressed: _onSupportSendMessagePressed,
      );
    } else if (index == 1) {
      result = MaterialDeliveredOrdersPage(
        onLoadMoreDeliveredOrders: () => _onLoadMoreDeliveredOrders(context),
        onSupportSendMessagePressed: _onSupportSendMessagePressed,
      );
    } else {
      result = MaterialSearchedOrdersPage(
        onLoadMoreSearchedOrders: (p0, p1, p2) => _onLoadMoreSearchedOrders(
          context: context,
          fromDate: p0,
          toDate: p1,
          orderId: p2,
        ),
        onSupportSendMessagePressed: _onSupportSendMessagePressed,
      );
    }
    return result;
  }

  void _onPageSwiped(int index) {
    if (_ordersViewCubit.state.isSyncingPages) return;
    _ordersViewCubit.setPage(index);
  }

  void _onPageSelected(int index) async {
    _ordersViewCubit.setSyncingState(true);
    _ordersViewCubit.setPage(index);
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (mounted) {
      _ordersViewCubit.setSyncingState(false);
    }
  }

  void _onLoadMoreNotDeliveredOrders(BuildContext context) {
    _ordersViewCubit.setLoadingState(true);
    context.read<CartBloc>().add(
      CartEventFetchNotDeliveredOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context
            .read<CartBloc>()
            .state
            .notDeliveredOrders
            ?.nextPageToken,
      ),
    );
  }

  void _onLoadMoreDeliveredOrders(BuildContext context) {
    _ordersViewCubit.setLoadingState(true);
    context.read<CartBloc>().add(
      CartEventFetchDeliveredOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context
            .read<CartBloc>()
            .state
            .deliveredOrders
            ?.nextPageToken,
      ),
    );
  }

  void _onLoadMoreSearchedOrders({
    required BuildContext context,
    DateTime? fromDate,
    DateTime? toDate,
    String? orderId,
  }) {
    _ordersViewCubit.setLoadingState(true);
    context.read<CartBloc>().add(
      CartEventFetchSearchedOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context
            .read<CartBloc>()
            .state
            .deliveredOrders
            ?.nextPageToken,
        fromDate: fromDate,
        toDate: toDate,
        orderId: orderId,
      ),
    );
  }

  void _onSearchBarPressed(BuildContext context) async {
    final dateRange = await openDateRangePicker(context);
    if (dateRange?.startDate != null &&
        dateRange?.endDate != null &&
        context.mounted) {
      _ordersViewCubit.setSearchFilterParameters(
        dateRange?.startDate,
        dateRange?.endDate,
      );
      context.read<CartBloc>().add(CartEventFlushSearchedOrders());
      _onLoadMoreSearchedOrders(
        context: context,
        fromDate: dateRange?.startDate,
        toDate: dateRange?.endDate,
      );
    }
  }

  void _changeSearchState() {
    _ordersViewCubit.setSearchingState(!_ordersViewCubit.state.isSerchOpen);
    _ordersViewCubit.setSearchFilterParameters(null, null);
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
              onLoadMore: () => _onLoadMoreNotDeliveredOrders(context),
              onBackButtonPressed: () => _onBackButtonPressed(context),
              onSupportSendMessagePressed: _onSupportSendMessagePressed,
              pageBuilder: (context, index) =>
                  _pageBuilder(context: context, index: index),
              onPageSwiped: (index) => _onPageSwiped(index),
              pageController: _pageController,
              onPageSelected: (index) => _onPageSelected(index),
              changeSearchState: _changeSearchState,
              onSearchBarPressed: () => _onSearchBarPressed(context),
            );
          },
        ),
      ),
    );
  }
}
