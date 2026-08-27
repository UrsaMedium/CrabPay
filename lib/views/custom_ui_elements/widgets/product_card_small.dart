import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class ProductCardSmallDriver extends StatelessWidget {
  final Product product; //also tag identoty
  final String tag;
  final double width;
  final double cornerRadius;
  final double padding;
  final String? optionalTag;
  const ProductCardSmallDriver({
    super.key,
    required this.product,
    required this.tag,
    required this.width,
    required this.cornerRadius,
    this.optionalTag,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cardTintColor = context.select<DatabaseBloc, int?>(
          (cubit) => cubit.state.cachedProductImageDominantColor?[product.id],
        );
        if (cardTintColor == null) {
          context.read<DatabaseBloc>().add(
            DatabaseEventGetProductCardTintColor(product: product),
          );
        }
        return _MaterialProductCardSmall(
          id: product.id,
          imageUrl: product.image,
          productName: product.name,
          description: product.description,
          tag: tag,
          width: width,
          cornerRadius: cornerRadius,
          cardTintColor: cardTintColor == null ? null : Color(cardTintColor),
          padding: padding,
        );
      },
    );
  }
}

class _MaterialProductCardSmall extends StatelessWidget {
  final String id;
  final String tag;
  final String imageUrl;
  final String productName;
  final String description;
  final double width;
  final double padding;
  final double cornerRadius;
  final Color? cardTintColor;
  const _MaterialProductCardSmall({
    required this.imageUrl,
    required this.productName,
    required this.description,
    required this.tag,
    required this.width,
    required this.cornerRadius,
    this.cardTintColor,
    required this.id,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width * 1.25,
      width: width,
      child: Material(
        clipBehavior: .antiAlias,
        shape: RoundedRectangleBorder(borderRadius: .circular(cornerRadius)),
        color: context.appColorScheme.surfaceContainer,
        elevation: 5,
        surfaceTintColor: cardTintColor ?? context.appColorScheme.primary,
        child: GestureDetector(
          onTap: () => globalOpenProductCardCallBack(
            context: context,
            productId: id,
            tag: tag,
          ),
          child: Column(
            crossAxisAlignment: .start,
            spacing: padding,
            children: [
              Padding(
                padding: .all(padding),
                child: Hero(
                  tag: tag,
                  createRectTween: (begin, end) =>
                      MaterialRectArcTween(begin: begin, end: end),
                  child: Material(
                    borderRadius: .circular(cornerRadius - padding),
                    clipBehavior: .antiAlias,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://regred-rainbowbridge.ru/crabpay/images/products/$imageUrl.png',
                      width: width - padding * 2,
                      height: width - padding * 2,
                      fit: .cover,
                      errorWidget: (context, error, stackTrace) => Container(
                        color: context.appColorScheme.onInverseSurface,
                        alignment: .center,
                        child: Text(context.l10n.emptyKey),
                      ),
                      placeholder: (context, url) =>
                          MaterialShimeringPlaceHolder(
                            width: width - 8,
                            height: width - 8,
                            cornerRadius: cornerRadius - 4,
                            color: context.appColorScheme.surfaceContainerHigh,
                          ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  productName,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: width / 7,
                    fontWeight: .w700,
                    color: context.appColorScheme.onPrimaryContainer,
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
