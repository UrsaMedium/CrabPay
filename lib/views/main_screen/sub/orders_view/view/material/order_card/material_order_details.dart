import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:flutter/material.dart';

Future<void> openOrderDetails(BuildContext context, CrabOrder order) async {
  await showDialog(
    context: context,
    builder: (context) {
      return MaterialOrderDetails(order: order);
    },
  );
}

String generateDetails(CartItem cartItem) {
  String result = '';
  for (var key in cartItem.purchaseData.keys) {
    result += '$key: ${cartItem.purchaseData[key]}\n';
  }
  return result.trimRight();
}

class MaterialOrderDetails extends StatelessWidget {
  final CrabOrder order;
  const MaterialOrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      child: Container(
        margin: .all(4),
        height: 356,
        width: 308,
        child: Column(
          children: [
            Card(
              color: context.appColorScheme.surfaceContainerLowest,
              margin: .all(0),
              shape: RoundedRectangleBorder(borderRadius: .circular(20)),
              child: Container(
                padding: const .symmetric(horizontal: 16, vertical: 4),
                // height: 104,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              order.orderDate,
                              style: const TextStyle(fontWeight: .w600),
                            ),
                            Text('Order: ${order.orderIdToDisplay}'),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Row(
                            children: [
                              Text(
                                'Support  ',
                                style: TextStyle(
                                  fontWeight: .w500,
                                  color:
                                      context.appColorScheme.onPrimaryContainer,
                                ),
                              ),
                              Icon(
                                Icons.send_rounded,
                                color:
                                    context.appColorScheme.onPrimaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text('Delivered'),
                              Text(' ${order.amountOfDeliveredItems}'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text('Products'),
                              Text(' ${order.amountOfItems}'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text('Order Price'),
                              Text(' \$${order.orderPrice}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: context.appColorScheme.surfaceContainerLow,
                borderRadius: .circular(20),
              ),
              margin: .only(top: 8),
              height: 244,
              width: 304,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: .all(12),
                    sliver: SliverList.builder(
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: .only(bottom: 4),
                          width: 288,
                          // height: 40,
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
                                      'https://regred-rainbowbridge.ru/crabpay/images/products/${order.itemsToImagesMap.values.toList()[index]}.png',
                                  fit: .cover,
                                  errorWidget: (context, error, stackTrace) =>
                                      Container(
                                        color: context
                                            .appColorScheme
                                            .onInverseSurface,
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              color: context
                                                  .appColorScheme
                                                  .inversePrimary,
                                              size: 16,
                                            ),
                                            Text(error),
                                          ],
                                        ),
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
                                        order.itemsToProductMap.values
                                            .toList()[index]
                                            .name,
                                      ),
                                      Text(
                                        '${order.items[index].checkoutPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: context.appColorScheme.primary,
                                          fontWeight: .w600,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context.appColorScheme.surfaceContainerHigh,
                                          borderRadius: .circular(10)
                                        ),
                                        padding: .all(4),
                                        child: Text(
                                          generateDetails(order.items[index]),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Row(
                                  children: [
                                    Text(
                                      'Support  ',
                                      style: TextStyle(
                                        fontWeight: .w500,
                                        color: context
                                            .appColorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                    Icon(
                                      Icons.send_rounded,
                                      color: context
                                          .appColorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ],
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
          ],
        ),
      ),
    );
  }
}
