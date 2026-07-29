import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/purchases_view/material_purchases_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

class PurchasesViewDriver extends StatefulWidget {
  const PurchasesViewDriver({super.key});

  @override
  State<PurchasesViewDriver> createState() => _PurchasesViewDriverState();
}

class _PurchasesViewDriverState extends State<PurchasesViewDriver> {
  final ScrollController _scrollController = ScrollController();
  late final PurchasesViewCubit _purchasesViewCubit;
  late final List<Product> _products;

  @override
  void initState() {
    _products = context.read<DatabaseBloc>().state.products ?? [];
    _purchasesViewCubit = PurchasesViewCubit();
    context.read<CartBloc>().add(CartEventFlushOrders());
    context.read<CartBloc>().add(
      CartEventFetchOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context.read<CartBloc>().state.orders?.nextPageToken,
      ),
    );
    _scrollController.addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _purchasesViewCubit.close();
    super.dispose();
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_purchasesViewCubit.state.isLoadingMore &&
        (context.read<CartBloc>().state.orders?.hasMore ?? false)) {
      context.read<CartBloc>().add(
        CartEventFetchOrders(
          userId: context.read<AuthBloc>().state.currentUser.id,
          pageToken: context.read<CartBloc>().state.orders?.nextPageToken,
        ),
      );
      _purchasesViewCubit.setLoadingState(true);
    }
  }

  void _onBackButtonPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'CasesViewDriver _onBackButtonPressed',
    );
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

  Map<CartItem, Product> _cartItemToProductMapping({
    required Map<String, List<CartItem>> itemsOfOrder,
  }) {
    Map<CartItem, Product> result = {};
    final allItems = itemsOfOrder.values.expand((element) => element);
    final uniqueItems = {
      for (var item in allItems) item.id: item,
    }.values.toList();
    for (var item in uniqueItems) {
      result[item] = _products.firstWhere(
        (product) => product.id == item.productId,
      );
    }
    return result;
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
        value: _purchasesViewCubit,
        child: BlocListener<CartBloc, CartState>(
          listenWhen: (previous, current) =>
              current.states == CartStates.loadedMoreOrders,
          listener: (context, state) {
            context.read<PurchasesViewCubit>().setLoadingState(false);
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return BlocBuilder<PurchasesViewCubit, PurchasesViewState>(
                builder: (context, viewState) {
                  return MaterialPurchasesView(
                    isLoadingMore: viewState.isLoadingMore,
                    scrollController: _scrollController,
                    orderGroups: cartState.itemsOfOrder ?? {},
                    cartItemToProductMap: _cartItemToProductMapping(
                      itemsOfOrder: cartState.itemsOfOrder ?? {},
                    ),
                    onBackButtonPressed: () => _onBackButtonPressed(context),
                    onSupportSendMessagePressed: _onSupportSendMessagePressed,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class PurchasesViewState {
  final bool isLoadingMore;

  PurchasesViewState({this.isLoadingMore = false});

  PurchasesViewState copyWith({bool? isLoadingMore}) {
    return PurchasesViewState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PurchasesViewCubit extends Cubit<PurchasesViewState> {
  PurchasesViewCubit() : super(PurchasesViewState());

  void setLoadingState(bool isLoading) {
    emit(state.copyWith(isLoadingMore: isLoading));
  }
}
