import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

typedef AppCustomTypeOrder = (
  String orderId,
  double totalPrice,
  String paymentLink,
);

class OrdersOnPaymentSheetDriver extends StatelessWidget {
  const OrdersOnPaymentSheetDriver({super.key});

  void _onPaymentLinkPressed(BuildContext context, String? link) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'ItemsOnPaymentSheetDriver _onPaymentLinkPressed',
    );
    if (link != null) {
      context.read<PaymentBloc>().add(PaymentEventReturnToProvider(link: link));
      context.pop();
    }
  }

  List<AppCustomTypeOrder> _orders(List<CartItem> items) {
    List<AppCustomTypeOrder> result = [];
    final orders = items.map((e) => e.paymentId).toSet().toList();
    for (var order in orders) {
      final orderItems = items.where((item) => item.paymentId == order);
      final total = orderItems.fold(
        0.0,
        (sum, item) => sum + item.checkoutPrice,
      );
      final link = orderItems.first.paymentLink;
      result.add((order!, total, link!));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final items = context.select<CartBloc, List<CartItem>>(
      (bloc) => bloc.state.cartItemsOnPaymentState ?? [],
    );
    return MaterialOrdersOnPaymentSheet(
      orders: _orders(items),
      onPaymentLinkPressed: (paymentLink) =>
          _onPaymentLinkPressed(context, paymentLink),
    );
  }
}

class MaterialOrdersOnPaymentSheet extends StatelessWidget {
  final Function(String) onPaymentLinkPressed;
  final List<AppCustomTypeOrder> orders;
  const MaterialOrdersOnPaymentSheet({
    super.key,
    required this.onPaymentLinkPressed,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              borderRadius: .circular(24),
              color: context.appColorScheme.secondary,
            ),
            child: Center(
              child: Text(
                orders.isEmpty
                    ? 'How Did You Get Here!?'
                    : 'Waiting Your Payment',
                style: TextStyle(
                  color: context.appColorScheme.onSecondary,
                  fontSize: 16,
                  fontWeight: .w600,
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            itemExtent: 100,
            itemBuilder: (context, index) =>
                OrderContainerForOrdersOnPaymentSheet(
                  order: orders[index].$1,
                  total: orders[index].$2,
                  link: orders[index].$3,
                  onPaymentLinkPressed: onPaymentLinkPressed,
                ),
          ),
        ),
      ],
    );
  }
}

class OrderContainerForOrdersOnPaymentSheet extends StatelessWidget {
  final String order;
  final double total;
  final String link;
  final Function(String) onPaymentLinkPressed;
  const OrderContainerForOrdersOnPaymentSheet({
    super.key,
    required this.order,
    required this.total,
    required this.link,
    required this.onPaymentLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, right: 36, bottom: 16),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
          borderRadius: .circular(24),
          color: context.appColorScheme.surfaceContainerHighest,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                spacing: 6,
                children: [
                  Text(
                    'Order: ${order.substring(0, 7)}',
                    style: TextStyle(
                      color: context.appColorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: .w500,
                    ),
                  ),
                  Text(
                    'Total: $total',
                    style: TextStyle(
                      color: context.appColorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => onPaymentLinkPressed(link),
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
