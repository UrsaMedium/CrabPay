import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPageView extends StatefulWidget {
  const CartPageView({super.key});

  @override
  State<CartPageView> createState() => _CartPageViewState();
}

class _CartPageViewState extends State<CartPageView> {
  List<CartItem>? cartItems;
  List<Product>? products;
  bool isLoggedIn = false;

  @override
  void initState() {
    products = context.read<DatabaseBloc>().state.products;
    super.initState();
  }

  Future<void> detaFetching(BuildContext context) async {
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    detaFetching(context);
    return Stack(
      clipBehavior: .antiAlias,
      children: [
        Scaffold(
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              cartItems = context.read<CartBloc>().state.cartItems;
              bool cartItemsNotEmpty = false;
              double total = 0;
              if (cartItems != null) {
                if (cartItems!.isNotEmpty) {
                  cartItemsNotEmpty = true;
                  for (var item in cartItems!) {
                    total = total + item.checkoutPrice;
                  }
                }
              }
              return Column(
                crossAxisAlignment: .stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
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
                            !cartItemsNotEmpty
                                ? const Center(child: Text('...'))
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: cartItems!.length,
                                    padding: .only(
                                      top: 8,
                                      bottom:
                                          MediaQuery.paddingOf(context).bottom +
                                          64,
                                    ),
                                    shrinkWrap: true,
                                    itemExtent: 86,
                                    itemBuilder: (context, index) {
                                      return CaertItemBuilder(
                                        cartItems: cartItems!,
                                        index: index,
                                        products: products!,
                                      );
                                    },
                                  ),
                          ],
                        ),
                        Positioned(
                          bottom: MediaQuery.paddingOf(context).bottom + 8,
                          right: 16,
                          left: 16,
                          child: Card(
                            elevation: 3,
                            clipBehavior: Clip.antiAlias,
                            color: context.appColorScheme.surfaceContainer
                                .withValues(alpha: .5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color:
                                    context.appColorScheme.surfaceContainerHigh,
                                width: 1,
                              ),
                            ),
                            child: BackdropFilter(
                              filter: .blur(sigmaX: 8, sigmaY: 8),
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
                                        onPressed: total == 0
                                            ? null
                                            : () {
                                                //TODO
                                                if (isLoggedIn) {
                                                  context.read<CartBloc>().add(
                                                    CartEventUserCheckoutItems(
                                                      checkoutItems: cartItems!,
                                                      status: 'beingCheckedOut',
                                                    ),
                                                  );
                                                  detaFetching(context);
                                                } else {}
                                              },
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
                                          isLoggedIn
                                              ? 'Checkout'
                                              : 'Sign In & Checkout',
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
                        SizedBox(height: MediaQuery.paddingOf(context).bottom),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CaertItemBuilder extends StatelessWidget {
  final List<Product> products;
  final List<CartItem> cartItems;
  final int index;
  const CaertItemBuilder({
    super.key,
    required this.products,
    required this.index,
    required this.cartItems,
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
        child: Padding(
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
                      'http://regred-rainbowbridge.ru/crabpay/images/products/${products.firstWhere((product) => product.id == cartItems[index].productId).image}.png',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        products
                            .firstWhere(
                              (product) =>
                                  product.id == cartItems[index].productId,
                            )
                            .name,
                      ),
                      Text(
                        '${cartItems[index].checkoutPrice}',
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
                  onPressed: () {
                    context.read<CartBloc>().add(
                      CartEventDeleteCartItem(cartItem: cartItems[index]),
                    );
                  },
                  icon: Icon(Icons.delete_outline_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
