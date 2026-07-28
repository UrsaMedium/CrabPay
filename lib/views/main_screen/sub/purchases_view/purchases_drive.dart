import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
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
  @override
  void initState() {
    context.read<CartBloc>().add(
      CartEventFetchOrders(
        userId: context.read<AuthBloc>().state.currentUser.id,
        pageToken: context.read<CartBloc>().state.orders?.nextPageToken,
      ),
    );
    super.initState();
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
      child: BlocProvider(
        create: (_) => PurchasesViewCubit(),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<PurchasesViewCubit, PurchasesViewState>(
              builder: (context, viewState) {
                return MaterialPurchasesView(
                  orderGroups: cartState.itemsOfOrder ?? {},
                  onBackButtonPressed: () => _onBackButtonPressed(context),
                  itemToProductMap: viewState.itemToProductMap ?? {},
                  onSupportSendMessagePressed: _onSupportSendMessagePressed,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PurchasesViewState {
  final List<CartItem>? itemsInProccess;
  final List<CartItem>? itemsDelivered;
  final Map<String, List<CartItem>>? orderGroups;
  final Map<CartItem, Product>? itemToProductMap;

  PurchasesViewState({
    this.itemsInProccess,
    this.itemsDelivered,
    this.orderGroups,
    this.itemToProductMap,
  });

  PurchasesViewState copyWith(
    List<CartItem>? itemsInProccess,
    List<CartItem>? itemsDelivered,
    Map<String, List<CartItem>>? orderGroups,
    Map<CartItem, Product>? itemToProductMap,
  ) {
    return PurchasesViewState(
      itemsInProccess: itemsInProccess ?? this.itemsInProccess,
      itemsDelivered: itemsDelivered ?? this.itemsDelivered,
      orderGroups: orderGroups ?? this.orderGroups,
      itemToProductMap: itemToProductMap ?? this.itemToProductMap,
    );
  }
}

class PurchasesViewCubit extends Cubit<PurchasesViewState> {
  PurchasesViewCubit() : super(PurchasesViewState());

  void sortCartItems({
    required List<CartItem> itemsAfterPayment,
    required List<Product> products,
  }) {
    final itemsInProccess = itemsAfterPayment
        .where((element) => element.status == 'paid')
        .toList();
    final itemsDelivered = itemsAfterPayment
        .where((element) => element.status == 'delivered')
        .toList();
    Map<String, List<CartItem>> orderGroups = {};
    for (final cartItem in itemsAfterPayment) {
      if (cartItem.paymentId != null) {
        var oldList = orderGroups[cartItem.paymentId] ?? [];
        oldList.add(cartItem);
        orderGroups[cartItem.paymentId!] = oldList;
      }
    }
    Map<CartItem, Product> itemToProductMap = {};
    for (var item in itemsAfterPayment) {
      itemToProductMap[item] = products.firstWhere(
        (product) => product.id == item.productId,
      );
    }
    emit(
      PurchasesViewState().copyWith(
        itemsInProccess,
        itemsDelivered,
        orderGroups,
        itemToProductMap,
      ),
    );
  }
}
