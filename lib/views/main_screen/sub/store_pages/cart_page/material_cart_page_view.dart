import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class MaterialCartPageView extends StatelessWidget {
  final Function(CartItem) onACartItemDelete;
  final List<Product> products;
  final bool isPaymentStateActive;
  final List<CartItem> cartItems;
  final double total;
  final CartItem theBeingDeletedCartItem;
  final VoidCallback onBuyPressed;
  final VoidCallback onPaymentLinkPressed;
  const MaterialCartPageView({
    super.key,
    required this.isPaymentStateActive,
    required this.cartItems,
    required this.total,
    required this.products,
    required this.onACartItemDelete,
    required this.theBeingDeletedCartItem,
    required this.onBuyPressed,
    required this.onPaymentLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .antiAlias,
      children: [
        Scaffold(
          body: Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: isPaymentStateActive,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.paddingOf(context).top + 16,
                              left: 16,
                            ),
                            child: Text(
                              'Shopping Cart',
                              textAlign: .left,
                              style: TextStyle(
                                color: context.appColorScheme.primaryFixedDim,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, bottom: 4.0),
                            child: Text(
                              'Confirm the purchase',
                              textAlign: .left,
                            ),
                          ),
                          cartItems.isEmpty
                              ? const Center(child: Text('...'))
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartItems.length,
                                  padding: .only(
                                    top: 8,
                                    bottom:
                                        MediaQuery.paddingOf(context).bottom +
                                        64,
                                  ),
                                  shrinkWrap: true,
                                  itemExtent: 86,
                                  itemBuilder: (context, index) {
                                    return CartItemForCartPageBuilder(
                                      onACartItemDelete: onACartItemDelete,
                                      isBeingDeleted:
                                          cartItems[index].id ==
                                          theBeingDeletedCartItem.id,
                                      cartItem: cartItems[index],
                                      product: products.firstWhere(
                                        (product) =>
                                            product.id ==
                                            cartItems[index].productId,
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.paddingOf(context).bottom + 18,
                      right: 16,
                      left: 16,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: .circular(30),
                        clipBehavior: .antiAlias,
                        child: BackdropFilter(
                          filter: .blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: context.appColorScheme.surfaceContainerHigh
                                .withValues(alpha: .8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16,
                                      left: 18,
                                      right: 18,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: .w500,
                                            ),
                                          ),
                                        ),
                                        Text('$total'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: cartItems.isEmpty
                                          ? null
                                          : onBuyPressed, //TODO
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.appColorScheme.primary,
                                        foregroundColor:
                                            context.appColorScheme.onPrimary,
                                        minimumSize: Size(
                                          double.maxFinite,
                                          50,
                                        ),
                                      ),
                                      child: Text(
                                        'Checkout',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
                    SizedBox(height: MediaQuery.paddingOf(context).bottom),
                    // if (isPaimentStateActive)
                    if (isPaymentStateActive)
                      Center(
                        child: BackdropFilter(
                          filter: .blur(sigmaX: 5, sigmaY: 5),
                          child: Column(
                            mainAxisAlignment: .center,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextButton(
                                  onPressed: onPaymentLinkPressed,
                                  child: Text(
                                    textAlign: .center,
                                    'You haven\'t pay yet\nTap here to go to the payment provider',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CartItemForCartPageBuilder extends StatelessWidget {
  final Function(CartItem) onACartItemDelete;
  final Product product;
  final CartItem cartItem;
  final bool isBeingDeleted;
  const CartItemForCartPageBuilder({
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
                      onPressed: () => onACartItemDelete(cartItem),
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
