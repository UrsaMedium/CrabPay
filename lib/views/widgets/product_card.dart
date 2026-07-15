import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCardDriver extends StatelessWidget {
  final OnOpenProductCardCallBack openProductCardCallBack;
  final Product product; //also tag identoty
  final String additionalSuffix; //tag identoty
  final int index; //tag identoty
  const ProductCardDriver({
    super.key,
    required this.openProductCardCallBack,
    required this.product,
    required this.additionalSuffix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    void onProductCardPressed() async {
      context.read<DatabaseBloc>().add(
        DatabaseEventFetchProductFields(productId: product.id),
      );
      context.read<CartBloc>().add(
        CartEventFetchProductCartItemAmount(
          userId: context.read<AuthBloc>().state.currentUser.id,
          productId: product.id,
        ),
      );
      await openProductCardCallBack(
        context: context,
        productId: product.id,
        additionalSuffix: additionalSuffix,
        index: index,
      );
      if (context.mounted) {
        context.read<CartBloc>().add(
          CartEventFetchUserCartItemAmount(
            userId: context.read<AuthBloc>().state.currentUser.id,
          ),
        );
      }
    }

    return MaterialProductCard(
      imageUrl: product.image,
      productName: product.name,
      description: product.description,
      onProductCardPressed: onProductCardPressed,
      tag: 'card-hero-${product.id}-$additionalSuffix-$index',
    );
  }
}

class MaterialProductCard extends StatelessWidget {
  final VoidCallback onProductCardPressed;
  final String tag;
  final String imageUrl;
  final String productName;
  final String description;
  const MaterialProductCard({
    super.key,
    required this.onProductCardPressed,
    required this.imageUrl,
    required this.productName,
    required this.description,
    required this.tag,
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
          onTap: onProductCardPressed,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              height: 200,
              child: Hero(
                tag: tag,
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
                            'https://regred-rainbowbridge.ru/crabpay/images/products/$imageUrl.png',
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
                            productName,
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
