import 'package:cached_network_image/cached_network_image.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_bloc.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_state.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPageView extends StatefulWidget {
  const CartPageView({super.key});

  @override
  State<CartPageView> createState() => _CartPageViewState();
}

class _CartPageViewState extends State<CartPageView> {
  late final AppLifecycleListener _lifecycleListener;
  List<CartItem>? _cartItems;
  List<Product>? _products;
  String? _paymentLink;
  int? _whosBeingDeletedIndex;

  @override
  void initState() {
    context.read<CartBloc>().add(
      CartEventFetchCartItems(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    _products = context.read<DatabaseBloc>().state.products;
    _lifecycleListener = AppLifecycleListener(
      onHide: () => _onUserLeave(context: context),
      onResume: () => _onUserReturn(context: context),
    );
    _onUserReturn(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _onUserLeave({required BuildContext context}) {
    print('--- User has left the app');
    List<String> cartItemIds = [];
    if (context.read<PaymentBloc>().state is PaymentStateListening) {
      for (var item in _cartItems!) {
        cartItemIds.add(item.id);
      }
      AppLocalStorage.saveCartItemsOnPayment(cartItemIds);
      //link is saved inside the PaymentBloc
    } else {
      AppLocalStorage.saveCartItemsOnPayment([]);
      AppLocalStorage.savePaymentLink('');
    }
    // _lifecycleListener.dispose();
  }

  void _onUserReturn({required BuildContext context}) {
    print('--- User has returned to the app');
    final cartItemIds = AppLocalStorage.getCartItemIdsOnPayment();
    if (cartItemIds != null) {
      context.read<PaymentBloc>().add(
        PaymentEventOnAppBackToLive(cartItemIds: cartItemIds),
      );
      _paymentLink = AppLocalStorage.getPaymentLink();
    }
  }

  void _onSpecificItemBeingDeleted(int index) {
    _whosBeingDeletedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        bool isPaimentStateActive = true;
        if (state is PaymentStateFailure ||
            state is PaymentStatePaid ||
            state is PaymentStateSilence) {
          isPaimentStateActive = false;
        } else {
          isPaimentStateActive = true;
          context.read<CartBloc>().add(
            CartEventFetchCartItems(
              userId: context.read<AuthBloc>().state.currentUser.id,
            ),
          );
          context.read<CartBloc>().add(
            CartEventFetchUserCartItemAmount(
              userId: context.read<AuthBloc>().state.currentUser.id,
            ),
          );
        }
        print('${state.toString()}');
        return Stack(
          clipBehavior: .antiAlias,
          children: [
            Scaffold(
              body: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final stateForTextButton = state;
                  final allCartItems = context.read<CartBloc>().state.cartItems;
                  bool cartItemsNotEmpty = false;
                  double total = 0;

                  if (allCartItems?.isNotEmpty ?? false) {
                    cartItemsNotEmpty = true;
                    _cartItems = [];
                    for (var item in allCartItems!) {
                      if (!([
                        'paid',
                        'delivered',
                        'canceled',
                      ].contains(item.status))) {
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
                            AbsorbPointer(
                              absorbing: isPaimentStateActive,
                              child: ListView(
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
                                        color: context
                                            .appColorScheme
                                            .primaryFixedDim,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      bottom: 4.0,
                                    ),
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
                                                MediaQuery.paddingOf(
                                                  context,
                                                ).bottom +
                                                64,
                                          ),
                                          shrinkWrap: true,
                                          itemExtent: 86,
                                          itemBuilder: (context, index) {
                                            return CartItemBuilder(
                                              onSpecificItemBeingDeleted:
                                                  _onSpecificItemBeingDeleted,
                                              whosBeingDeletedId:
                                                  _whosBeingDeletedIndex,
                                              cartItems: _cartItems!,
                                              index: index,
                                              products: _products!,
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: MediaQuery.paddingOf(context).bottom + 8,
                              right: 16,
                              left: 16,
                              child: AbsorbPointer(
                                absorbing: isPaimentStateActive,
                                child: Card(
                                  elevation: 7,
                                  shadowColor: Colors.black.withValues(
                                    alpha: .3,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  color: context.appColorScheme.surfaceContainer
                                      .withValues(alpha: .5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: context
                                          .appColorScheme
                                          .surfaceContainerHigh,
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
                                            child: BlocListener<PaymentBloc, PaymentState>(
                                              listener: (context, state) {
                                                if (state
                                                        is PaymentStateUserAtProvider &&
                                                    _cartItems != null) {
                                                  context
                                                      .read<PaymentBloc>()
                                                      .add(
                                                        PaymentEventListen(
                                                          cartItems:
                                                              _cartItems!,
                                                        ),
                                                      );
                                                }
                                                if (state
                                                        is PaymentStateFailure ||
                                                    state is PaymentStatePaid) {
                                                  context
                                                      .read<PaymentBloc>()
                                                      .add(
                                                        PaymentEventSilence(),
                                                      );
                                                  context.read<CartBloc>().add(
                                                    CartEventFetchCartItems(
                                                      userId: context
                                                          .read<AuthBloc>()
                                                          .state
                                                          .currentUser
                                                          .id,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: ElevatedButton(
                                                onPressed:
                                                    !(total == 0 ||
                                                        _cartItems != null)
                                                    ? null
                                                    : () {
                                                        context
                                                            .read<PaymentBloc>()
                                                            .add(
                                                              PaymentEventPay(
                                                                provider:
                                                                    'YooPay',
                                                                cartItems:
                                                                    _cartItems!,
                                                              ),
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
                                                child: Text(
                                                  'Checkout',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
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
                            SizedBox(
                              height: MediaQuery.paddingOf(context).bottom,
                            ),
                            // if (isPaimentStateActive)
                            if (isPaimentStateActive)
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
                                      if (stateForTextButton
                                          is! PaymentStateSilence)
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextButton(
                                            onPressed: () {
                                              if (_paymentLink != null) {
                                                context.read<PaymentBloc>().add(
                                                  PaymentEventReturnToProvider(
                                                    link: _paymentLink!,
                                                  ),
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: 'No link',
                                                );
                                              }
                                            },
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
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartItemBuilder extends StatelessWidget {
  final Function(int) _onSpecificItemBeingDeleted;
  final int? _whosBeingDeletedId;
  final List<Product> _products;
  final List<CartItem> _cartItems;
  final int _index;
  const CartItemBuilder({
    super.key,
    required List<Product> products,
    required int index,
    required List<CartItem> cartItems,
    required Function(int) onSpecificItemBeingDeleted,
    required int? whosBeingDeletedId,
  }) : _whosBeingDeletedId = whosBeingDeletedId,
       _onSpecificItemBeingDeleted = onSpecificItemBeingDeleted,
       _index = index,
       _cartItems = cartItems,
       _products = products;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            color: context.appColorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(
                color: context.appColorScheme.surfaceContainerHigh,
              ),
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
                              'https://regred-rainbowbridge.ru/crabpay/images/products/${_products.firstWhere((product) => product.id == _cartItems[_index].productId).image}.png',
                          fit: .cover,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                                color: context.appColorScheme.onInverseSurface,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color:
                                          context.appColorScheme.inversePrimary,
                                      size: 48,
                                    ),
                                    Text('$error'),
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
                              Text(
                                _products
                                    .firstWhere(
                                      (product) =>
                                          product.id ==
                                          _cartItems[_index].productId,
                                    )
                                    .name,
                              ),
                              Text(
                                '${_cartItems[_index].checkoutPrice}',
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
                            _onSpecificItemBeingDeleted(_index);
                            context.read<CartBloc>().add(
                              CartEventDeleteCartItem(
                                cartItem: _cartItems[_index],
                                userId: context
                                    .read<AuthBloc>()
                                    .state
                                    .currentUser
                                    .id,
                              ),
                            );
                          },
                          icon: Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.states == CartStates.deleting &&
                    _index == _whosBeingDeletedId)
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
      },
    );
  }
}
