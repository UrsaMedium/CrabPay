import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class ProductCardDriver extends StatelessWidget {
  final Product product; //also tag identoty
  final String tag;
  final double height;
  final double width;
  final double cornerRadius;
  final String? optionalTag;
  const ProductCardDriver({
    super.key,
    required this.product,
    required this.tag,
    required this.height,
    required this.width,
    required this.cornerRadius,
    this.optionalTag,
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
        return MaterialProductCard(
          id: product.id,
          imageUrl: product.image,
          productName: product.name,
          description: product.description,
          tag: tag,
          height: height,
          width: width,
          cornerRadius: cornerRadius,
          cardTintColor: cardTintColor == null ? null : Color(cardTintColor),
        );
      },
    );
  }
}

class MaterialProductCard extends StatelessWidget {
  final String id;
  final String tag;
  final String imageUrl;
  final String productName;
  final String description;
  final double height;
  final double width;
  final double cornerRadius;
  final Color? cardTintColor;
  const MaterialProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.description,
    required this.tag,
    required this.height,
    required this.width,
    required this.cornerRadius,
    this.cardTintColor,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.all(0),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Hero(
                  tag: tag,
                  createRectTween: (begin, end) =>
                      MaterialRectArcTween(begin: begin, end: end),
                  child: Material(
                    borderRadius: .circular(cornerRadius - 4),
                    clipBehavior: .antiAlias,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://regred-rainbowbridge.ru/crabpay/images/products/$imageUrl.png',
                      width: width - 8,
                      height: height - 110,
                      fit: .cover,
                      errorWidget: (context, error, stackTrace) => Container(
                        color: context.appColorScheme.onInverseSurface,
                        alignment: Alignment.center,
                        child: Text(context.l10n.emptyKey),
                      ),
                      placeholder: (context, url) =>
                          MaterialShimeringPlaceHolder(
                            width: width - 8,
                            height: height - 110,
                            cornerRadius: cornerRadius - 4,
                            color: context.appColorScheme.surfaceContainerHigh,
                          ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 2,
                ),
                child: Text(
                  productName,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: .w700,
                    color: context.appColorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Battle Pass & Credits',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: .w400,
                    color: context.appColorScheme.onSurface.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4,
                ),
                child: Text(
                  '\$2.49',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: .w900,
                    color: context.appColorScheme.onSurface,
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
