import 'package:crabpay/core/product_data/product_controller.dart';
import 'package:crabpay/core/product_data/product_model.dart';
import 'package:crabpay/views/store_views/store_pages/card_view/buy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardView extends StatelessWidget {
  static const routeName = 'card-view';
  final String productId;
  const CardView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    AppProductController productController = AppProductController();
    AppProduct product = productController.findById(productId);

    return Hero(
      tag: 'card-hero-${product.id}',
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Image.asset(product.image),
            Text(product.name),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => BuyBottomSheet(),
                );
              },
              child: Text("Buy"),
            ),
          ],
        ),
      ),
    );
  }
}
