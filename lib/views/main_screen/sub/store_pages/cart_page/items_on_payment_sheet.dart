import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ItemsOnPaymentSheetDriver extends StatelessWidget {
  const ItemsOnPaymentSheetDriver({super.key});

  void _onPaymentLinkPressed(BuildContext context, String? link) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'ItemsOnPaymentSheetDriver _onPaymentLinkPressed',
    );
    print(link);
    if (link != null) {
      context.read<PaymentBloc>().add(PaymentEventReturnToProvider(link: link));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartTems =
        context.read<CartBloc>().state.cartItemsOnPaymentState ?? [];
    final products = context.read<DatabaseBloc>().state.products ?? [];
    return MaterialItemsOnPaymentSheet(
      cartItems: cartTems,
      products: products,
      onPaymentLinkPressed: () =>
          _onPaymentLinkPressed(context, cartTems.first.paymentLink),
    );
  }
}

class MaterialItemsOnPaymentSheet extends StatelessWidget {
  final VoidCallback onPaymentLinkPressed;
  final List<CartItem> cartItems;
  final List<Product> products;
  const MaterialItemsOnPaymentSheet({
    super.key,
    required this.cartItems,
    required this.products,
    required this.onPaymentLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
          child: ElevatedButton(
            onPressed: () => onPaymentLinkPressed(),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColorScheme.primary,
              foregroundColor: context.appColorScheme.onPrimary,
              minimumSize: Size(double.maxFinite, 50),
            ),
            child: Text(
              'Click The Payment Link',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            padding: .only(
              top: 8,
              bottom: MediaQuery.paddingOf(context).bottom + 64 - cornerRadius,
            ),
            shrinkWrap: true,
            itemExtent: 86,
            itemBuilder: (context, index) {
              return CartItemWidgetDriver(
                onACartItemDelete: null,
                isBeingDeleted: false,
                cartItem: cartItems[index],
                product: products.firstWhere(
                  (product) => product.id == cartItems[index].productId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
