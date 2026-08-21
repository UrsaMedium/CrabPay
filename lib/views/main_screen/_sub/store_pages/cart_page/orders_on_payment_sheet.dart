import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersOnPaymentSheetDriver extends StatelessWidget {
  const OrdersOnPaymentSheetDriver({super.key});

  void _onPaymentLinkPressed(BuildContext context, String? link) {
    if (link != null) {
      context.read<PaymentBloc>().add(PaymentEventReturnToProvider(link: link));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders = context.select<CartBloc, List<PendingOrder>>(
      (bloc) => bloc.state.pendingOrders ?? [],
    );
    return MaterialOrdersOnPaymentSheet(
      orders: pendingOrders,
      onPaymentLinkPressed: (paymentLink) =>
          _onPaymentLinkPressed(context, paymentLink),
    );
  }
}

class MaterialOrdersOnPaymentSheet extends StatelessWidget {
  final Function(String) onPaymentLinkPressed;
  final List<PendingOrder> orders;
  const MaterialOrdersOnPaymentSheet({
    super.key,
    required this.onPaymentLinkPressed,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (cubit) => cubit.state.highGraphics,
    );
    return Material(
      color: context.appColorScheme.surfaceContainer.withValues(
        alpha: highGraphics ? .5 : .95,
      ),
      borderRadius: .vertical(top: .circular(24)),
      clipBehavior: .antiAlias,
      child: BackdropFilter(
        enabled: highGraphics,
        filter: .blur(sigmaX: 12, sigmaY: 12),
        child: Wrap(
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
                      order: orders[index].paymentId.substring(0, 7),
                      total: orders[index].totalPrice,
                      link: orders[index].paymentLink,
                      onPaymentLinkPressed: onPaymentLinkPressed,
                    ),
              ),
            ),
          ],
        ),
      ),
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
    return Container(
      margin: const .only(left: 36, right: 36, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: .circular(24),
        color: context.appColorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const .all(16.0),
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
                  'Order: $order',
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
    );
  }
}
