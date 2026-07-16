import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CasesViewDriver extends StatefulWidget {
  const CasesViewDriver({super.key});

  @override
  State<CasesViewDriver> createState() => _CasesViewDriverState();
}

class _CasesViewDriverState extends State<CasesViewDriver> {
  void _onBackButtonPressed(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAfterPayment = context.select<CartBloc, List<CartItem>>(
      (bloc) => bloc.state.cartItemsProccessed ?? [],
    );
    final itemsInProccess = itemsAfterPayment
        .where((element) => element.status == 'paid')
        .toList();
    final itemsDelivered = itemsAfterPayment
        .where((element) => element.status == 'delivered')
        .toList();
    return MaterialCasesView(
      itemsDelivered: itemsDelivered,
      itemsInProccess: itemsInProccess,
      onBackButtonPressed: () => _onBackButtonPressed(context),
      products: context.read<DatabaseBloc>().state.products ?? [],
    );
  }
}

class MaterialCasesView extends StatelessWidget {
  final List<CartItem> itemsInProccess;
  final List<CartItem> itemsDelivered;
  final List<Product> products;
  final VoidCallback onBackButtonPressed;
  const MaterialCasesView({
    super.key,
    required this.onBackButtonPressed,
    required this.itemsInProccess,
    required this.itemsDelivered,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBackButtonPressed,
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Proccessing'),
            itemsInProccess.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemsInProccess.length,
                    padding: .only(
                      top: 8,
                      bottom: MediaQuery.paddingOf(context).bottom + 64,
                    ),
                    shrinkWrap: true,
                    itemExtent: 86,
                    itemBuilder: (context, index) =>
                        MaterialCartItemForCasesBuilder(
                          cartItem: itemsInProccess[index],
                          product: products.firstWhere(
                            (element) =>
                                element.id == itemsInProccess[index].productId,
                          ),
                        ),
                  )
                : Text('No Items yet'),
            Text('Delivered'),
            SizedBox(height: 40),
            itemsDelivered.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: itemsDelivered.length,
                    padding: .only(
                      top: 8,
                      bottom: MediaQuery.paddingOf(context).bottom + 64,
                    ),
                    shrinkWrap: true,
                    itemExtent: 86,
                    itemBuilder: (context, index) =>
                        MaterialCartItemForCasesBuilder(
                          cartItem: itemsDelivered[index],
                          product: products.firstWhere(
                            (element) =>
                                element.id == itemsDelivered[index].productId,
                          ),
                        ),
                  )
                : Text('No items yet'),
          ],
        ),
      ),
    );
  }
}

class MaterialCartItemForCasesBuilder extends StatelessWidget {
  final Product product;
  final CartItem cartItem;
  const MaterialCartItemForCasesBuilder({
    super.key,
    required this.product,
    required this.cartItem,
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
                      onPressed: null,
                      icon: Icon(Icons.send_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
