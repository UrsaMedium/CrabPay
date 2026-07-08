import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Function(BuildContext, String, String, String) openProductCardCallBack;
  final Product product; //also tag identoty
  final String additionalSuffix; //tag identoty
  final String index; //tag identoty
  const ProductCard({
    super.key,
    required this.product,
    required this.openProductCardCallBack,
    required this.additionalSuffix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Card(
        clipBehavior: .antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(32),
          side: BorderSide(
            color: context.appColorScheme.primary.withValues(alpha: .3),
          ),
        ),
        color: context.appColorScheme.surfaceContainer,
        child: GestureDetector(
          onTap: () {
            openProductCardCallBack(
              context,
              product.id,
              additionalSuffix,
              index,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              height: 200,
              child: Hero(
                tag: 'card-hero-${product.id}-$additionalSuffix-$index',
                createRectTween: (begin, end) =>
                    MaterialRectArcTween(begin: begin, end: end),

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(32),
                      ),
                      clipBehavior: .antiAlias,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
                        width: double.infinity,
                        height: 200,
                        fit: .cover,
                        errorWidget: (context, error, stackTrace) => Container(
                          color: context.appColorScheme.onInverseSurface,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            color: context.appColorScheme.inversePrimary,
                            size: 48,
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          color: context.appColorScheme.onInverseSurface,
                          alignment: .center,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 32,
                      child: Container(
                        padding: .symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: context.appColorScheme.primaryContainer,
                        ),
                        child: Material(
                          type: .transparency,
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.appColorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
