import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:crabpay/views/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

class MaterialCartPageView extends StatelessWidget {
  final Function(CartItem) onACartItemDelete;
  final List<Product> products;
  final bool isPaymentStateActive;
  final List<CartItem> cartItemsToBuy;
  final List<CartItem> cartItemsOnPaymentState;
  final double total;
  final CartItem theBeingDeletedCartItem;
  final VoidCallback onBuyPressed;
  final VoidCallback onShowBottonSheet;
  const MaterialCartPageView({
    super.key,
    required this.isPaymentStateActive,
    required this.cartItemsToBuy,
    required this.total,
    required this.products,
    required this.onACartItemDelete,
    required this.theBeingDeletedCartItem,
    required this.onBuyPressed,
    required this.cartItemsOnPaymentState,
    required this.onShowBottonSheet,
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
                    ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 16),
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
                          child: Text('Confirm the purchase', textAlign: .left),
                        ),
                        cartItemsToBuy.isEmpty
                            ? const Center(child: Text('...'))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItemsToBuy.length,
                                padding: .only(
                                  top: 8,
                                  bottom:
                                      MediaQuery.paddingOf(context).bottom +
                                      64 -
                                      cornerRadius,
                                ),
                                shrinkWrap: true,
                                // itemExtent: 84,
                                itemBuilder: (context, index) {
                                  return CartItemWidgetDriver(
                                    onACartItemDelete: onACartItemDelete,
                                    isBeingDeleted:
                                        cartItemsToBuy[index].id ==
                                        theBeingDeletedCartItem.id,
                                    cartItem: cartItemsToBuy[index],
                                    product: products.firstWhere(
                                      (product) =>
                                          product.id ==
                                          cartItemsToBuy[index].productId,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                    Positioned(
                      bottom: MediaQuery.paddingOf(context).bottom + 8,
                      right: 16,
                      left: 16,
                      child: Stack(
                        children: [
                          Material(
                            color: Colors.transparent,
                            borderRadius: .circular(24),
                            clipBehavior: .antiAlias,
                            child: BackdropFilter(
                              enabled: context.highGraphics,
                              filter: .blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                height: cartItemsOnPaymentState.isNotEmpty
                                    ? 186
                                    : 128,
                                color: context
                                    .appColorScheme
                                    .surfaceContainerHigh
                                    .withValues(
                                      alpha: context.highGraphics ? .5 : .97,
                                    ),
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
                                          onPressed:
                                              (cartItemsToBuy.isEmpty ||
                                                  cartItemsOnPaymentState
                                                      .isNotEmpty)
                                              ? null
                                              : onBuyPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                context.appColorScheme.primary,
                                            foregroundColor: context
                                                .appColorScheme
                                                .onPrimary,
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
                                      if (cartItemsOnPaymentState.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            top: 8,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: onShowBottonSheet,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: context
                                                  .appColorScheme
                                                  .primary,
                                              foregroundColor: context
                                                  .appColorScheme
                                                  .onPrimary,
                                              minimumSize: Size(
                                                double.maxFinite,
                                                50,
                                              ),
                                            ),
                                            child: Text(
                                              'You have Unpaid ${cartItemsOnPaymentState.length} Order!',
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
                          IgnorePointer(
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: .topCenter,
                                end: .bottomCenter,
                                colors: [
                                  context.appColorScheme.outline.withValues(
                                    alpha: .2,
                                  ),
                                  context.appColorScheme.outline.withValues(
                                    alpha: .1,
                                  ),
                                  Colors.transparent,
                                  Colors.transparent,
                                  context.appColorScheme.outline.withValues(
                                    alpha: .1,
                                  ),
                                ],
                              ).createShader(bounds),
                              child: Container(
                                height: cartItemsOnPaymentState.isNotEmpty
                                    ? 186
                                    : 128,
                                decoration: BoxDecoration(
                                  borderRadius: .circular(24),
                                  border: .all(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom),
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
