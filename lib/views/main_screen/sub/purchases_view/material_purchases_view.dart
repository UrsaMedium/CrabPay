import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialPurchasesView extends StatelessWidget {
  final List<CartItem> itemsInProccess;
  final List<CartItem> itemsDelivered;
  final Map<String, List<CartItem>> orderGroups;
  final Map<CartItem, Product> itemToProductMap;
  final VoidCallback onBackButtonPressed;
  const MaterialPurchasesView({
    super.key,
    required this.onBackButtonPressed,
    required this.itemsInProccess,
    required this.itemsDelivered,
    required this.orderGroups,
    required this.itemToProductMap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBackButtonPressed,
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: .all(8),
                decoration: BoxDecoration(
                  color: context.appColorScheme.surfaceContainerHigh,
                  borderRadius: .circular(24),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderGroups.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: index == 0
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.only(top: 8),
                    child: MaterialPurchasesCard(
                      cartItems:
                          orderGroups[orderGroups.keys.elementAt(index)] ?? [],
                      itemToProductMap: itemToProductMap,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaterialPurchasesCard extends StatelessWidget {
  final List<CartItem> cartItems;
  final Map<CartItem, Product> itemToProductMap;
  const MaterialPurchasesCard({
    super.key,
    required this.itemToProductMap,
    required this.cartItems,
  });

  List<Widget> _rowOfProductImages() {
    List<Widget> result = [];
    for (var item in cartItems) {
      result.add(
        Row(
          spacing: 8,
          children: [
            Container(
              height: 64,
              clipBehavior: .antiAlias,
              decoration: BoxDecoration(borderRadius: .circular(12)),
              child: AspectRatio(
                aspectRatio: 1.4,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://regred-rainbowbridge.ru/crabpay/images/products/${itemToProductMap[item]?.image}.png',
                  fit: .cover,
                  errorWidget: (context, error, stackTrace) => Container(
                    color: context.appColorScheme.onInverseSurface,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: context.appColorScheme.inversePrimary,
                          size: 16,
                        ),
                        Text(error),
                      ],
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    color: context.appColorScheme.onInverseSurface,
                    alignment: .center,
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(item.productName),
                Text('RUB: ${item.checkoutPrice}'),
              ],
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  Text('Status'),
                  Text(
                    item.status == 'delivered'
                        ? item.status
                        : 'being delivered',
                    style: TextStyle(
                      color: item.status == 'delivered'
                          ? Colors.greenAccent
                          : Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .all(0),
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          spacing: 6,
          children: [
            Container(
              margin: .only(bottom: 4),
              padding: .all(4),
              decoration: BoxDecoration(
                color: context.appColorScheme.primaryContainer,
                borderRadius: .circular(12),
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    '  Order: ${cartItems.first.paymentId!.substring(0, 8)}',
                    style: TextStyle(
                      color: context.appColorScheme.onPrimaryContainer,
                      fontSize: 18,
                      fontWeight: .w500,
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
                            color: context.appColorScheme.onPrimaryContainer,
                          ),
                        ),
                        Icon(
                          Icons.send_rounded,
                          color: context.appColorScheme.onPrimaryContainer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ..._rowOfProductImages(),
          ],
        ),
      ),
    );
  }
}
