import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/extensions/l10n_extension.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/material_shimering_place_holder.dart';
import 'package:flutter/material.dart';

class ProductCardImageOnly extends StatelessWidget {
  final Product product;
  final String tag;
  final double width;
  final double height;
  final double cornerRadius;
  final double margin;
  const ProductCardImageOnly({
    super.key,
    required this.product,
    required this.tag,
    required this.width,
    required this.height,
    required this.cornerRadius,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = '${product.id}-$tag';
    return GestureDetector(
      onTap: () => globalOpenProductCardCallBack(
        context: context,
        productId: product.id,
        tag: heroTag,
      ),
      child: Container(
        margin: .symmetric(horizontal: margin),
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: .circular(cornerRadius)),
        clipBehavior: .antiAlias,
        child: Hero(
          tag: heroTag,
          createRectTween: (begin, end) =>
              MaterialRectArcTween(begin: begin, end: end),
          child: CachedNetworkImage(
            imageUrl:
                'https://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
            fit: .cover,
            errorWidget: (context, error, stackTrace) => Container(
              color: context.appColorScheme.onInverseSurface,
              alignment: Alignment.center,
              child: Text(context.l10n.emptyKey),
            ),
            placeholder: (context, url) => MaterialShimeringPlaceHolder(
              width: width,
              height: height,
              cornerRadius: cornerRadius,
              color: context.appColorScheme.surfaceContainerHigh,
            ),
          ),
        ),
      ),
    );
  }
}
