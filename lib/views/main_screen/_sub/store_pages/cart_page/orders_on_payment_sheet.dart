import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
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

  void _onOrderDetailsPressed(
    BuildContext context,
    List<Product> products,
    PendingOrder order,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _OrderDetails(order: order, products: products);
      },
    );
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
      onOrderDetailsPressed: (order) => _onOrderDetailsPressed(
        context,
        context.read<DatabaseBloc>().state.products ?? [],
        order,
      ),
    );
  }
}

class MaterialOrdersOnPaymentSheet extends StatelessWidget {
  final Function(String) onPaymentLinkPressed;
  final List<PendingOrder> orders;
  final Function(PendingOrder) onOrderDetailsPressed;
  const MaterialOrdersOnPaymentSheet({
    super.key,
    required this.onPaymentLinkPressed,
    required this.orders,
    required this.onOrderDetailsPressed,
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
            Padding(
              padding: const .only(bottom: 16),
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemExtent: 100,
                  itemBuilder: (context, index) =>
                      OrderContainerForOrdersOnPaymentSheet(
                        order: orders[index],
                        onPaymentLinkPressed: onPaymentLinkPressed,
                        onDetailsPressed: (order) =>
                            onOrderDetailsPressed(order),
                      ),
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
  final PendingOrder order;
  final Function(String) onPaymentLinkPressed;
  final Function(PendingOrder) onDetailsPressed;
  const OrderContainerForOrdersOnPaymentSheet({
    super.key,
    required this.order,
    required this.onPaymentLinkPressed,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .only(left: 36, right: 36, bottom: 8),
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
                  'Order: ${order.paymentId.substring(0, 7)}',
                  style: TextStyle(
                    color: context.appColorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: .w500,
                  ),
                ),
                Text(
                  'Total: ${order.totalPrice}',
                  style: TextStyle(
                    color: context.appColorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 4,
              children: [
                ElevatedButton(
                  onPressed: () => onDetailsPressed(order),
                  child: Icon(Icons.more_horiz_rounded),
                ),
                ElevatedButton(
                  onPressed: () => onPaymentLinkPressed(order.paymentLink),
                  child: Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String generateDetails(CartItem cartItem) {
  String result = '';
  for (var key in cartItem.purchaseData.keys) {
    result += '$key: ${cartItem.purchaseData[key]}\n';
  }
  return result.trimRight();
}

class _OrderDetails extends StatelessWidget {
  final PendingOrder order;
  final List<Product> products;
  const _OrderDetails({required this.order, required this.products});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      child: Container(
        margin: .all(4),
        height: 360,
        width: 308,
        child: Column(
          spacing: 4,
          crossAxisAlignment: .start,
          children: [
            Card(
              color: context.appColorScheme.surfaceContainerLowest,
              margin: .all(0),
              shape: RoundedRectangleBorder(borderRadius: .circular(20)),
              child: Container(
                margin: .all(8),
                padding: const .symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              dateConversion(
                                order.cartItems.last.createdAt.toString(),
                              ),
                              style: const TextStyle(fontWeight: .w600),
                            ),
                            Text('Order: ${order.paymentId.substring(0, 7)}'),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: .start,
                            children: [
                              Text('Products'),
                              Text(' ${order.cartItems.length}'),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: .start,
                            children: [
                              Text('Order Price'),
                              Text(' \$${order.totalPrice}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: context.appColorScheme.surfaceContainerLow,
                  borderRadius: .circular(20),
                ),
                // height: 244,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: .all(12),
                      sliver: SliverList.builder(
                        itemCount: order.cartItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: .only(bottom: 4),
                            width: 288,
                            child: Row(
                              crossAxisAlignment: .start,
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Container(
                                  margin: .only(top: 8),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: .circular(8),
                                  ),
                                  clipBehavior: .antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://regred-rainbowbridge.ru/crabpay/images/products/${(products.firstWhere((element) => element.id == order.cartItems[index].productId)).image}.png',
                                    fit: .cover,
                                    errorWidget: (context, error, stackTrace) =>
                                        Container(
                                          color: context
                                              .appColorScheme
                                              .onInverseSurface,
                                          alignment: Alignment.center,
                                          child: Text('🦀'),
                                        ),
                                    placeholder: (context, url) =>
                                        MaterialShimeringPlaceHolder(
                                          width: 40,
                                          height: 40,
                                          cornerRadius: 8,
                                          color: context
                                              .appColorScheme
                                              .surfaceContainerHigh,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: .symmetric(
                                      horizontal: 16.0,
                                      vertical: 4,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          order.cartItems[index].productName,
                                        ),
                                        Text(
                                          '${order.cartItems[index].checkoutPrice}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                context.appColorScheme.primary,
                                            fontWeight: .w600,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .appColorScheme
                                                .surfaceContainerHigh,
                                            borderRadius: .circular(10),
                                          ),
                                          padding: .all(4),
                                          child: Text(
                                            generateDetails(
                                              order.cartItems[index],
                                            ),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
