import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';

class CartItemWidgetDriver extends StatelessWidget {
  final Function(CartItem)? onACartItemDelete;
  final Product product;
  final CartItem cartItem;
  final bool isBeingDeleted;
  const CartItemWidgetDriver({
    super.key,
    required this.onACartItemDelete,
    required this.product,
    required this.cartItem,
    required this.isBeingDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCartItemWidget(
      cartItem: cartItem,
      isBeingDeleted: isBeingDeleted,
      onACartItemDelete: onACartItemDelete,
      product: product,
    );
  }
}

class MaterialCartItemWidget extends StatelessWidget {
  final Function(CartItem)? onACartItemDelete;
  final Product product;
  final CartItem cartItem;
  final bool isBeingDeleted;
  const MaterialCartItemWidget({
    super.key,
    required this.onACartItemDelete,
    required this.product,
    required this.cartItem,
    required this.isBeingDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        color: context.appColorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: context.appColorScheme.surfaceContainerHigh),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://regred-rainbowbridge.ru/crabpay/images/products/${product.image}.png',
                      fit: .cover,
                      errorWidget: (context, error, stackTrace) => Container(
                        color: context.appColorScheme.onInverseSurface,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: context.appColorScheme.inversePrimary,
                              size: 48,
                            ),
                            Text(error),
                          ],
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        color: context.appColorScheme.onInverseSurface,
                        alignment: .center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(product.name),
                          Text(
                            '${cartItem.checkoutPrice}',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.appColorScheme.primary,
                              fontWeight: .w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: context.appColorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      iconSize: 25,
                      padding: .all(0),
                      onPressed: onACartItemDelete != null
                          ? () => onACartItemDelete!(cartItem)
                          : null,
                      icon: Icon(Icons.delete_outline_rounded),
                    ),
                  ),
                ],
              ),
            ),
            if (isBeingDeleted)
              BackdropFilter(
                filter: .blur(sigmaX: 5, sigmaY: 5),
                child: AbsorbPointer(
                  absorbing: true,
                  child: ClipRRect(
                    borderRadius: .circular(50),
                    child: Center(child: Text('Deleting')),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
