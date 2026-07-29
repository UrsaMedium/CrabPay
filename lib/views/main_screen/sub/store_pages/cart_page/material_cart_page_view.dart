import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';
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
                                itemExtent: 86,
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
                      bottom:
                          MediaQuery.paddingOf(context).bottom +
                          18 -
                          cornerRadius,
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
                                      onPressed:
                                          (cartItemsToBuy.isEmpty ||
                                              cartItemsOnPaymentState
                                                  .isNotEmpty)
                                          ? null
                                          : onBuyPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.appColorScheme.primary,
                                        foregroundColor:
                                            context.appColorScheme.onPrimary,
                                        minimumSize: Size(double.maxFinite, 50),
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
                                        onPressed:
                                            //  cartItemsOnPaymentState.isEmpty
                                            //     ? null
                                            //     :
                                            onShowBottonSheet,
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
                                          'You have Unpaid Order!',
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
