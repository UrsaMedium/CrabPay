import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/main_screen/sub/purchases_view/purchases_drive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialPurchasesView extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final VoidCallback onLoadMore;
  final Function(String) onSupportSendMessagePressed;
  const MaterialPurchasesView({
    super.key,
    required this.onBackButtonPressed,
    required this.onSupportSendMessagePressed,
    required this.onLoadMore,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // controller: scrollController,
          slivers: [
            Builder(
              builder: (context) {
                final orderGroups = context
                    .select<PurchasesViewCubit, Map<String, List<CartItem>>>(
                      (cubit) => cubit.state.orderGroups ?? {},
                    );
                final orderEntries = orderGroups.entries.toList();

                return SliverList.builder(
                  itemCount: orderGroups.length,
                  itemBuilder: (context, index) {
                    final group = orderEntries[index];
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.only(top: 8),
                      child: MaterialPurchasesCard(
                        cartItems: group.value,
                        onSupportSendMessagePressed:
                            onSupportSendMessagePressed,
                      ),
                    );
                  },
                );
              },
            ),
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  final isLoadingMore = context
                      .select<PurchasesViewCubit, bool>(
                        (cubit) => cubit.state.isLoadingMore,
                      );
                  final hasMore = context.select<PurchasesViewCubit, bool>(
                    (cubit) => cubit.state.hasMore,
                  );
                  return ElevatedButton(
                    onPressed: hasMore ? onLoadMore : null,
                    child: isLoadingMore
                        ? CircularProgressIndicator()
                        : Text(hasMore ? 'Load More' : 'That\'s it'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialPurchasesCard extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(String) onSupportSendMessagePressed;
  const MaterialPurchasesCard({
    super.key,
    required this.cartItems,
    required this.onSupportSendMessagePressed,
  });

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
              margin: const .only(bottom: 4),
              padding: const .symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: context.appColorScheme.primaryContainer,
                borderRadius: .circular(12),
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        dateConversion(
                          cartItems.first.statusChangedAt.toString(),
                        ),
                        style: const TextStyle(fontWeight: .w600),
                      ),
                      Text(
                        'Order: ${cartItems.first.paymentId!.substring(0, 8)}',
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => onSupportSendMessagePressed(
                      '${cartItems.first.paymentId}',
                    ),
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
            Container(height: 52),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [Text('Delivered'), Text(' --')],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [Text('Products'), Text(' ---')],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [Text('Order Price'), Text(' \$ --')],
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

class MaterialCustomWidgetRowOfImages extends StatelessWidget {
  const MaterialCustomWidgetRowOfImages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}





  // List<Widget> _rowOfProductImages() {
  //   List<Widget> result = [];
  //   for (var item in cartItems) {
  //     result.add(
  //       Row(
  //         spacing: 8,
  //         children: [
  //           Container(
  //             height: 64,
  //             clipBehavior: .antiAlias,
  //             decoration: BoxDecoration(borderRadius: .circular(12)),
  //             child: AspectRatio(
  //               aspectRatio: 1.4,
  //               child: CachedNetworkImage(
  //                 imageUrl:
  //                     'https://regred-rainbowbridge.ru/crabpay/images/products/${itemToProductMap[item]?.image}.png',
  //                 fit: .cover,
  //                 errorWidget: (context, error, stackTrace) => Container(
  //                   color: context.appColorScheme.onInverseSurface,
  //                   alignment: Alignment.center,
  //                   child: Column(
  //                     children: [
  //                       Icon(
  //                         Icons.broken_image,
  //                         color: context.appColorScheme.inversePrimary,
  //                         size: 16,
  //                       ),
  //                       Text(error),
  //                     ],
  //                   ),
  //                 ),
  //                 placeholder: (context, url) => Container(
  //                   color: context.appColorScheme.onInverseSurface,
  //                   alignment: .center,
  //                   child: const CircularProgressIndicator(),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Column(
  //             crossAxisAlignment: .start,
  //             children: [
  //               Text(item.productName),
  //               Text('RUB: ${item.checkoutPrice}'),
  //             ],
  //           ),
  //           Spacer(flex: 1),
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: Column(
  //               crossAxisAlignment: .end,
  //               children: [
  //                 Text('Status'),
  //                 Text(
  //                   item.status == 'delivered'
  //                       ? item.status
  //                       : 'being delivered',
  //                   style: TextStyle(
  //                     color: item.status == 'delivered'
  //                         ? Colors.greenAccent
  //                         : Colors.yellowAccent,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return result;
  // }