import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/main_screen/_sub/orders_view/driver/crab_order_model.dart';
import 'package:crabpay/views/main_screen/_sub/orders_view/driver/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialOrderCard extends StatelessWidget {
  final CrabOrder crabOrder;
  final Function(String) onSupportSendMessagePressed;
  final VoidCallback onOrederCardPressed;
  const MaterialOrderCard({
    super.key,
    required this.onSupportSendMessagePressed,
    required this.crabOrder,
    required this.onOrederCardPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: onOrederCardPressed,
        child: Card(
          color: context.appColorScheme.surfaceContainerLowest,
          margin: .all(0),
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              spacing: 8,
              children: [
                Container(
                  margin: const .only(bottom: 8),
                  padding: const .symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.appColorScheme.surfaceContainerLow,
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
                      Builder(
                        builder: (context) {
                          final isMessageSending = context
                              .select<OrdersViewCubit, bool>(
                                (cubit) => cubit.state.isSupportMessageSending,
                              );
                          return IconButton(
                            onPressed: isMessageSending
                                ? null
                                : () => onSupportSendMessagePressed(
                                    'The user requested help on order: \n ${crabOrder.orderId}',
                                  ),
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
                                isMessageSending
                                    ? CircularProgressIndicator()
                                    : Icon(
                                        Icons.send_rounded,
                                        color: context
                                            .appColorScheme
                                            .onPrimaryContainer,
                                      ),
                              ],
                            ),
                          );
                        },
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
              child: Text('🦀'),
            ),
            placeholder: (context, url) => MaterialShimeringPlaceHolder(
              width: 40,
              height: 40,
              cornerRadius: 4,
              color: context.appColorScheme.surfaceContainerHigh,
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
