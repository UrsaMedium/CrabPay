import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

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
          onTap: () async {
            await context.pushNamed(
              'card_view',
              pathParameters: {'productId': product.id},
            );
            if (context.mounted) {
              context.read<CartBloc>().add(
                CartEventFetchUserCartItemAmount(
                  userId: context.read<AuthBloc>().state.currentUser!.id,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              height: 200,
              child: Hero(
                tag: 'card-hero-${product.id}',
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
                            'http://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
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
