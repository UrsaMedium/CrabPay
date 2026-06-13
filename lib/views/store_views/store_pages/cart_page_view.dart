import 'dart:ui';

import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_states.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartPageView extends StatefulWidget {
  const CartPageView({super.key});

  @override
  State<CartPageView> createState() => _CartPageViewState();
}

class _CartPageViewState extends State<CartPageView> {
  List<CartItem>? cartItems;
  List<Product>? products;
  AuthUser? currentUser;

  @override
  void initState() {
    products = context.read<DatabaseBloc>().state.products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isLoggedIn = false;
        if (state is AuthStateLoggedIn) isLoggedIn = true;
        currentUser = state.currentUser;
        currentUser == null
            ? ()
            : context.read<CartBloc>().add(
                CartEventFetchCartItems(userId: currentUser!.id),
              );
        return Stack(
          clipBehavior: .antiAlias,
          children: [
            Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<CartBloc, CartState>(
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text('Confirm the purchase', textAlign: .left),
                        ),
                        Expanded(
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              !cartItemsNotEmpty
                                  ? SliverToBoxAdapter(child: Text('...'))
                                  : SliverList.builder(
                                      itemCount: cartItems!.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 3,
                                          clipBehavior: Clip.antiAlias,
                                          color: context
                                              .appColorScheme
                                              .surfaceContainer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            side: BorderSide(
                                              color: context
                                                  .appColorScheme
                                                  .surfaceContainerHigh,
                                            ),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  child: Image.network(
                                                    'http://regred-rainbowbridge.ru/crabpay/images/products/${products!.firstWhere((product) => product.id == cartItems![index].productId).image}',
                                                    fit: .cover,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          .start,
                                                      children: [
                                                        Text(
                                                          products!
                                                              .firstWhere(
                                                                (product) =>
                                                                    product
                                                                        .id ==
                                                                    cartItems![index]
                                                                        .productId,
                                                              )
                                                              .name,
                                                        ),
                                                        Text(
                                                          '${cartItems![index].checkoutPrice}',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: context
                                                                .appColorScheme
                                                                .primary,
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
                                                    color: context
                                                        .appColorScheme
                                                        .onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 25,
                                                    padding: .all(0),
                                                    onPressed: () {
                                                      context.read<CartBloc>().add(
                                                        CartEventDeleteCartItem(
                                                          cartItem:
                                                              cartItems![index],
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 3,
                          clipBehavior: Clip.antiAlias,
                          color: context.appColorScheme.surfaceContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color:
                                  context.appColorScheme.surfaceContainerHigh,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16,

                                    left: 16,
                                    right: 16,
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
                                ElevatedButton(
                                  onPressed: total == 0 ? null : () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        context.appColorScheme.primary,
                                    foregroundColor:
                                        context.appColorScheme.onPrimary,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: Text(
                                    'Checkout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            if (!isLoggedIn)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: GestureDetector(
                    onTap: () {},
                    behavior: .opaque,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        children: [
                          Text(
                            'Shopping Cart',
                            textAlign: .center,
                            style: TextStyle(
                              color: context.appColorScheme.primaryFixedDim,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'You are not authorized. Please, sign in',
                            textAlign: .center,
                            style: TextStyle(
                              color: context.appColorScheme.primaryFixedDim,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/login_view');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.appColorScheme.primary,
                                foregroundColor:
                                    context.appColorScheme.onPrimary,
                                minimumSize: Size(130, 50),
                              ),
                              child: Text(
                                'Sign In',
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
          ],
        );
      },
    );
  }
}
