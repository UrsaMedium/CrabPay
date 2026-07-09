import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_service.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPageView extends StatefulWidget {
  const CartPageView({super.key});

  @override
  State<CartPageView> createState() => _CartPageViewState();
}

class _CartPageViewState extends State<CartPageView> {
  List<CartItem>? _cartItems;
  List<String> _cartItemIds = [];
  List<Product>? _products;
  final PaymentOuterHandler _paymentService = PaymentOuterHandler();
  bool _isLoadingLink = false;

  @override
  void initState() {
    _products = context.read<DatabaseBloc>().state.products;
    super.initState();
  }

  @override
  void dispose() {
    _paymentService.disposeListener();
    super.dispose();
  }

  Future<void> detaFetching(BuildContext context) async {
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
  }

  Future<void> _onPaymentCall({required double totalAmount}) async {
    setState(() {
      _isLoadingLink = true;
    });

    try {
      if (_cartItems != null) {
        final String paymentUrl = await _paymentService.createPaymentLink(
          cartItemIds: _cartItemIds,
          totalAmount: totalAmount,
        );
        final Uri url = Uri.parse(paymentUrl);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Failed to launch $paymentUrl');
        }
      } else {
        Fluttertoast.showToast(msg: 'Nothing to pay for');
        print('no cart tiems');
        return;
      }
    } catch (e) {
      print('--- Payment error: $e');
    } finally {
      setState(() {
        _isLoadingLink = false;
      });
    }
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
              final allCartItems = context.read<CartBloc>().state.cartItems;
              bool cartItemsNotEmpty = false;
              double total = 0;

              if (allCartItems?.isNotEmpty ?? false) {
                cartItemsNotEmpty = true;
                _cartItems = [];
                for (var item in allCartItems!) {
                  if (item.status != 'paid') {
                    _cartItems!.add(item);
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
                                    itemCount: _cartItems!.length,
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
                                        cartItems: _cartItems!,
                                        index: index,
                                        products: _products!,
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
                                      child: StreamBuilder<String>(
                                        stream: _paymentService
                                            .listenToPaymentStatus(
                                              _cartItemIds,
                                            ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data == 'paid') {
                                            context.read<CartBloc>().add(
                                              CartEventFetchCartItems(
                                                userId: context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .currentUser
                                                    .id,
                                              ),
                                            );
                                            print('--- Paid successfuly');
                                          } else if (snapshot.hasData &&
                                              snapshot.data == 'failed') {
                                            context.read<CartBloc>().add(
                                              CartEventFetchCartItems(
                                                userId: context
                                                    .read<AuthBloc>()
                                                    .state
                                                    .currentUser
                                                    .id,
                                              ),
                                            );
                                            Fluttertoast.showToast(
                                              msg: 'Payment fail :(',
                                            );
                                            print('-- payment is failed');
                                          }

                                          return ElevatedButton(
                                            onPressed: total == 0
                                                ? null
                                                : () async {
                                                    _cartItemIds = [];
                                                    double totalAmount = 0;
                                                    for (var item
                                                        in _cartItems!) {
                                                      _cartItemIds.add(item.id);
                                                      totalAmount +=
                                                          item.checkoutPrice;
                                                    }
                                                    _isLoadingLink
                                                        ? null
                                                        : _onPaymentCall(
                                                            totalAmount:
                                                                totalAmount,
                                                          );
                                                  },
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
                                            child: _isLoadingLink
                                                ? CircularProgressIndicator()
                                                : Text(
                                                    'Checkout',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                          );
                                        },
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
