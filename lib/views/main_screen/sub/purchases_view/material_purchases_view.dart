import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/purchases_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/sub/purchases_view/driver/cubit.dart';
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
                final crabOrders = context
                    .select<PurchasesViewCubit, List<CrabOrder>>(
                      (cubit) => cubit.state.crabOrders ?? [],
                    );

                return SliverList.builder(
                  itemCount: crabOrders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.only(top: 8),
                      child: MaterialPurchasesCard(
                        crabOrder: crabOrders[index],
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
  final CrabOrder crabOrder;
  final Function(String) onSupportSendMessagePressed;
  const MaterialPurchasesCard({
    super.key,
    required this.onSupportSendMessagePressed,
    required this.crabOrder,
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
                        crabOrder.orderDate,
                        style: const TextStyle(fontWeight: .w600),
                      ),
                      Text('Order: ${crabOrder.orderIdToDisplay}'),
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
            Container(
              margin: .symmetric(horizontal: 8),
              child: MaterialCustomWidgetRowOfImages(
                images: crabOrder.itemsToImagesMap.values.toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Delivered'),
                      Text(' ${crabOrder.amountOfDeliveredItems}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Products'),
                      Text(' ${crabOrder.amountOfItems}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Order Price'),
                      Text(' \$${crabOrder.orderPrice}'),
                    ],
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
  final List<String> images;
  const MaterialCustomWidgetRowOfImages({super.key, required this.images});

  List<Widget> _rowOfImages(BuildContext context) {
    List<Widget> result = [];
    for (var image in images.length > 5 ? images.getRange(0, 6) : images) {
      result.add(
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: .circular(4)),
          clipBehavior: .antiAlias,
          child: CachedNetworkImage(
            imageUrl:
                'https://regred-rainbowbridge.ru/crabpay/images/products/$image.png',
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
          ),
        ),
      );
    }
    if (images.length > 5) {
      result.add(
        Container(
          margin: .symmetric(horizontal: 8),
          alignment: .center,
          height: 30,
          width: 40,
          decoration: BoxDecoration(
            color: context.appColorScheme.surfaceContainerHighest,
            borderRadius: .circular(12),
          ),
          child: Text('+${images.length - 6}'),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 2, children: _rowOfImages(context));
  }
}
