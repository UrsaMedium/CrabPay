import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
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
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'ProductCardDriver onProductCardPressed',
        data: {'productId': product.id},
      );
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
    return Card(
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      color: context.appColorScheme.surfaceContainer,
      elevation: 5,
      child: GestureDetector(
        onTap: onProductCardPressed,
        child: Hero(
          tag: tag,
          createRectTween: (begin, end) =>
              MaterialRectArcTween(begin: begin, end: end),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  borderRadius: .circular(12),
                  clipBehavior: .antiAlias,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://regred-rainbowbridge.ru/crabpay/images/products/$imageUrl.png',
                    width: double.maxFinite,
                    height: 190,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                child: Text(
                  productName,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w800,
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
                    color: context.appColorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
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
