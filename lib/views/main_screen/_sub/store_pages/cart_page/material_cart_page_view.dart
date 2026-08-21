import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:crabpay/views/custom_ui_elements/utilities/ui_utilities.dart';
import 'package:crabpay/core/global_graphic_driver.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/cart_item_widget.dart';
import 'package:crabpay/views/main_screen/_sub/store_pages/cart_page/driver/cart_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialCartPageView extends StatelessWidget {
  final Future<void> Function() reFresher;
  final Function(CartItem) onACartItemDelete;
  final VoidCallback onBuyPressed;
  final VoidCallback onShowBottonSheet;
  const MaterialCartPageView({
    super.key,
    required this.onACartItemDelete,
    required this.onBuyPressed,
    required this.onShowBottonSheet,
    required this.reFresher,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: reFresher,
      child: Stack(
        clipBehavior: .antiAlias,
        children: [
          Scaffold(
            body: Column(
              crossAxisAlignment: .stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      _ListOfCartItemsWidget(
                        onACartItemDelete: (p0) => onACartItemDelete(p0),
                      ),
                      _BuyPannelWidget(
                        onBuyPressed: onBuyPressed,
                        onShowBottonSheet: onShowBottonSheet,
                      ),
                      SizedBox(height: MediaQuery.paddingOf(context).bottom),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListOfCartItemsWidget extends StatelessWidget {
  final Function(CartItem) onACartItemDelete;
  const _ListOfCartItemsWidget({required this.onACartItemDelete});

  @override
  Widget build(BuildContext context) {
    final cartItemsToBuy = context.select<CartPageCubit, List<CartItem>>(
      (cubit) => cubit.state.cartItemsTuBuy ?? [],
    );
    return ListView(
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
            ? Center(
                child: Padding(
                  padding: const .symmetric(vertical: 16),
                  child: Text(
                    'Hey, You haven\'t pick anything',
                    style: TextStyle(
                      color: context.appColorScheme.secondary,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItemsToBuy.length,
                padding: .only(
                  top: 8,
                  bottom:
                      MediaQuery.paddingOf(context).bottom + 64 - cornerRadius,
                ),
                shrinkWrap: true,
                // itemExtent: 84,
                itemBuilder: (context, index) {
                  return CartItemWidgetDriver(
                    onACartItemDelete: onACartItemDelete,
                    cartItem: cartItemsToBuy[index],
                    product: context
                        .read<CartPageCubit>()
                        .state
                        .products
                        .firstWhere(
                          (product) =>
                              product.id == cartItemsToBuy[index].productId,
                        ),
                  );
                },
              ),
      ],
    );
  }
}

class _BuyPannelWidget extends StatelessWidget {
  final VoidCallback onBuyPressed;
  final VoidCallback onShowBottonSheet;
  const _BuyPannelWidget({
    required this.onBuyPressed,
    required this.onShowBottonSheet,
  });

  @override
  Widget build(BuildContext context) {
    final pendingOrders = context.select<CartPageCubit, List<PendingOrder>>(
      (cubit) => cubit.state.pendingOrder ?? [],
    );
    final cartItemsToBuy = context.select<CartPageCubit, List<CartItem>>(
      (cubit) => cubit.state.cartItemsTuBuy ?? [],
    );
    final highGraphics = context.select<GlobalGraphicBloc, bool>(
      (bloc) => bloc.state.highGraphics,
    );
    return Positioned(
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
              enabled: highGraphics,
              filter: .blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: pendingOrders.isNotEmpty ? 186 : 128,
                color: context.appColorScheme.surfaceContainerHigh.withValues(
                  alpha: highGraphics ? .5 : .97,
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
                            Text(
                              '${context.read<CartPageCubit>().state.totalPrice}',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: cartItemsToBuy.isEmpty
                              ? null
                              : onBuyPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appColorScheme.primary,
                            foregroundColor: context.appColorScheme.onPrimary,
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
                      if (pendingOrders.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 8,
                          ),
                          child: ElevatedButton(
                            onPressed: onShowBottonSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColorScheme.primary,
                              foregroundColor: context.appColorScheme.onPrimary,
                              minimumSize: Size(double.maxFinite, 50),
                            ),
                            child: Text(
                              pendingOrders.length == 1
                                  ? 'You have 1 Unpaid Order!'
                                  : 'You have ${pendingOrders.length} Unpaid Orders!',
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
                  context.appColorScheme.outline.withValues(alpha: .2),
                  context.appColorScheme.outline.withValues(alpha: .1),
                  Colors.transparent,
                  Colors.transparent,
                  context.appColorScheme.outline.withValues(alpha: .1),
                ],
              ).createShader(bounds),
              child: Container(
                height: pendingOrders.isNotEmpty ? 186 : 128,
                decoration: BoxDecoration(
                  borderRadius: .circular(24),
                  border: .all(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
