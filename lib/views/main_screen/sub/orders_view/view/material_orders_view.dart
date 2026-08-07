import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/custom_ui_elements/custom_faster_page_scroll_physics.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/driver/cubit.dart';
import 'package:crabpay/views/main_screen/sub/orders_view/view/material_custom_orders_view_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialOrdersView extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final VoidCallback onLoadMore;
  final Function(String) onSupportSendMessagePressed;
  final PageController pageController;
  final Function(int) onPageSwiped;
  final Function(int) onPageSelected;
  final Function(BuildContext, int) pageBuilder;
  const MaterialOrdersView({
    super.key,
    required this.onBackButtonPressed,
    required this.onSupportSendMessagePressed,
    required this.onLoadMore,
    required this.pageController,
    required this.onPageSwiped,
    required this.pageBuilder,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MaterialCustomOrdersViewAppbar(
        onBackButtonPressed: onBackButtonPressed,
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: 2,
            physics: const CustomFasterPageScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageSwiped,
            itemBuilder: (context, index) => pageBuilder(context, index),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top * 2 + 12,
            left: 8,
            right: 8,
            child: Material(
              borderRadius: .circular(14),
              clipBehavior: .antiAlias,
              color: Colors.transparent,
              child: BackdropFilter(
                enabled: context.highGraphics,
                filter: .blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 36,
                  // width: 46,
                  decoration: BoxDecoration(
                    color: context.appColorScheme.surfaceContainer.withValues(
                      alpha: context.highGraphics ? .5 : .97,
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      final page = context.select<OrdersViewCubit, int>(
                        (cubit) => cubit.state.page,
                      );
                      return Row(
                        mainAxisAlignment: .spaceAround,
                        spacing: 8,
                        children: [
                          GestureDetector(
                            onTap: onPageSelected(0),
                            child: Container(
                              padding: .symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: page == 0
                                    ? context.appColorScheme.primary
                                    : null,
                                borderRadius: .circular(16),
                              ),
                              child: Text(
                                'Being Delivered',
                                style: TextStyle(
                                  color: page == 0
                                      ? context.appColorScheme.onPrimary
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onPageSelected(1),
                            child: Container(
                              padding: .symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: page == 1
                                    ? context.appColorScheme.primary
                                    : null,
                                borderRadius: .circular(16),
                              ),
                              child: Text(
                                'Delivered',
                                style: TextStyle(
                                  color: page == 1
                                      ? context.appColorScheme.onPrimary
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialOrderCard extends StatelessWidget {
  final CrabOrder crabOrder;
  final Function(String) onSupportSendMessagePressed;
  const MaterialOrderCard({
    super.key,
    required this.onSupportSendMessagePressed,
    required this.crabOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
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
