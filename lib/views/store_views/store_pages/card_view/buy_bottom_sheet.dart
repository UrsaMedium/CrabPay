import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  final List<ProductField> productFields;
  final Currencies currency;
  const BuyBottomSheet({
    super.key,
    required this.productId,
    required this.productFields,
    required this.currency,
  });

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  Map<String, String> retrievedData = {};
  double precalculatedPrice = 0;
  List<String> functionDimentions = [];
  Product? product;
  ProductField? imageField;
  late final AuthUser currentUser;
  List<CartItem>? theCartItems;
  int itemsCount = 0;
  bool everyFieldIsSatisfied = false;

  @override
  void initState() {
    product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == widget.productId,
    );
    imageField = widget.productFields.firstWhere((field) => field.isPriceImage);
    currentUser = context.read<AuthBloc>().state.currentUser ?? appTempUser;
    context.read<CartBloc>().add(
      CartEventFetchCartItems(userId: currentUser.id),
    );
    final allCartItems = context.read<CartBloc>().state.cartItems;
    allCartItems == null ? theCartItems = null : theCartItems = [];
    if (allCartItems != null) {
      for (var cartItem in allCartItems) {
        if (cartItem.productId == product!.id) {
          theCartItems!.add(cartItem);
        }
      }
      itemsCount = theCartItems!.length;
    }

    super.initState();
  }

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      retrievedData[fieldName] = dataReceived;
      if (imageField != null) {
        if (imageField!.handler == 'InputField') {
          final dataFromIamgeField = retrievedData[imageField!.fieldName];
          final imageCoefficient =
              imageField!.priceImages![dataFromIamgeField] ?? 0;
          precalculatedPrice =
              double.parse(dataFromIamgeField ?? '0') * imageCoefficient;
        } else {
          double retrievedPrice = 0;
          final dataFromIamgeField = retrievedData[imageField!.fieldName];
          retrievedPrice = imageField!.priceImages![dataFromIamgeField] ?? 0;
          precalculatedPrice = retrievedPrice;
        }
      } else {
        Fluttertoast.showToast(msg: 'eee');
      }

      everyFieldIsSatisfied =
          (retrievedData.length == widget.productFields.length);
      if (everyFieldIsSatisfied) {
        for (var retrievedField in retrievedData.keys) {
          if (retrievedData[retrievedField]!.isEmpty) {
            everyFieldIsSatisfied = false;
            break;
          }
        }
      }

      //TODO internal testing
      if (everyFieldIsSatisfied) {
        for (var originalField in widget.productFields) {
          if (!retrievedData.containsKey(originalField.fieldName)) {
            everyFieldIsSatisfied = false;
            Fluttertoast.showToast(
              msg:
                  'Retrieved field ${originalField.fieldName} is not among retrieved from input fields',
            );
            break;
          }
        }
      }
      //TODO internal testing
    });
  }

  List<Widget> _fieldSlivers(List<ProductField> fields) {
    fields.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 8, right: 128),
          child: SizedBox(
            child: Text(
              product?.name ?? 'error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: .w700,
                color: context.appColorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    ];
    for (var field in fields) {
      result.add(
        SliverToBoxAdapter(
          child: theAppWidgetBuilder(
            collectedDataBridge: _onBottomSheetDataRetrieved,
            context: context,
            fieldName: field.fieldName,
            handler: field.handler,
            priceImages: field.priceImages,
            expectedData: field.expectedData,
          ),
        ),
      );
    }
    result.add(SliverToBoxAdapter(child: SizedBox(height: 66)));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: .only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: .blur(sigmaX: 16, sigmaY: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.58,
                      ),
                      child: Stack(
                        children: [
                          CustomScrollView(
                            shrinkWrap: true,
                            slivers: _fieldSlivers(widget.productFields),
                          ),
                          // if (!isLoggedIn)
                          //   Positioned.fill(
                          //     child: Material(
                          //       color: Colors.transparent,
                          //       child: InkWell(
                          //         onTap: () => Fluttertoast.showToast(
                          //           msg: 'You are not singed in',
                          //         ),
                          //         child: const SizedBox.expand(),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.states == CartStates.failedToAdd) {
                      itemsCount -= 1;
                      Fluttertoast.showToast(msg: 'Faild to add');
                    } else {
                      // Fluttertoast.showToast(msg: 'It\'s in your cart now');
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: .end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 16,
                                right: 16,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Container(
                                    height: 44,
                                    width: 100,
                                    alignment: .center,
                                    padding: .only(left: 16, right: 16),
                                    decoration: BoxDecoration(
                                      color: precalculatedPrice == 0
                                          ? context
                                                .appColorScheme
                                                .surfaceContainerHigh
                                                .withValues(alpha: .5)
                                          : context.appColorScheme.onPrimary
                                                .withValues(alpha: .5),
                                      borderRadius: BorderRadius.circular(30),
                                      border: BoxBorder.all(
                                        color: precalculatedPrice == 0
                                            ? context
                                                  .appColorScheme
                                                  .surfaceContainer.withValues(alpha: .5)
                                            : context.appColorScheme.onPrimary,
                                      ),
                                    ),
                                    child: Text(
                                      precalculatedPrice == 0
                                          ? '--'
                                          : '\$$precalculatedPrice',
                                      overflow: .clip,
                                      style: TextStyle(
                                        color: context.appColorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(flex: 1),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 8,
                            // top: 12,
                          ),
                          child: SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                if (itemsCount > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      // top: 8,
                                      right: 8,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: .circular(30),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Container(
                                          height: 45,
                                          alignment: .center,
                                          padding: .only(left: 16, right: 16),
                                          decoration: BoxDecoration(
                                            color: context
                                                .appColorScheme
                                                .primary
                                                .withValues(alpha: .5),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            border: BoxBorder.all(
                                              color: context
                                                  .appColorScheme
                                                  .outline,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                // style: ElevatedButton.styleFrom(
                                                //   backgroundColor:
                                                //       context.appColorScheme.primaryContainer,
                                                // ),
                                                onPressed: () {
                                                  itemsCount -= 1;
                                                 context.read<CartBloc>().add(
                                                    CartEventDeleteCartItem(
                                                      cartItem:
                                                          theCartItems!.last,
                                                    ),
                                                  );
                                                  theCartItems!.removeLast();
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .exposure_minus_1_rounded,
                                                  color: context
                                                      .appColorScheme
                                                      .onPrimary,
                                                ),
                                              ),
                                              VerticalDivider(width: 4),
                                              IconButton(
                                                onPressed: () =>
                                                    context.go('/cart'),
                                                icon: Badge(
                                                  backgroundColor: context
                                                      .appColorScheme
                                                      .onError,
                                                  textColor: context
                                                      .appColorScheme
                                                      .error,
                                                  label: AnimatedSwitcher(
                                                    duration: const Duration(
                                                      milliseconds: 250,
                                                    ),
                                                    transitionBuilder:
                                                        (
                                                          Widget child,
                                                          Animation<double>
                                                          animation,
                                                        ) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: SlideTransition(
                                                              position:
                                                                  Tween<Offset>(
                                                                    begin:
                                                                        const Offset(
                                                                          2,
                                                                          0.0,
                                                                        ),
                                                                    end: Offset
                                                                        .zero,
                                                                  ).animate(
                                                                    animation,
                                                                  ),
                                                              child: child,
                                                            ),
                                                          );
                                                        },
                                                    child: Text(
                                                      '$itemsCount',
                                                      key: ValueKey<int>(
                                                        itemsCount,
                                                      ),
                                                    ),
                                                  ),
                                                  isLabelVisible:
                                                      itemsCount > 0,
                                                  child: Icon(
                                                    color: context
                                                        .appColorScheme
                                                        .onPrimary,
                                                    Icons
                                                        .shopping_cart_checkout_rounded,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Flexible(
                                  child: ClipRRect(
                                    borderRadius: .circular(30),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // if (isLoggedIn &&
                                          //     currentUser != null) {
                                          if (everyFieldIsSatisfied) {
                                            CartItem cartItem = CartItem(
                                              id: 'id',
                                              userId: currentUser.id,
                                              userName: currentUser.email,
                                              productId: widget.productId,
                                              productName: product!.name,
                                              purchaseData: retrievedData,
                                              currency: widget.currency.name,
                                              checkoutPrice: precalculatedPrice,
                                              status: 'created',
                                            );
                                            try {
                                              context.read<CartBloc>().add(
                                                CartEventAddCartItem(
                                                  cartItem: cartItem,
                                                  userId: currentUser.id,
                                                ),
                                              );
                                              itemsCount += 1;
                                              Fluttertoast.showToast(
                                                msg: 'It\'s in your cart now',
                                              );
                                            } on Exception catch (e) {
                                              Fluttertoast.showToast(
                                                msg: 'Bee: $e',
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: 'Every field must be filled',
                                            );
                                          }
                                          // } else {
                                          //   context.go('/login_view');
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: everyFieldIsSatisfied
                                              ? context.appColorScheme.primary
                                                    .withValues(alpha: .5)
                                              : context.appColorScheme.onPrimary
                                                    .withValues(alpha: 0.5),
                                          foregroundColor: everyFieldIsSatisfied
                                              ? context.appColorScheme.onPrimary
                                              : context.appColorScheme.primary,
                                          minimumSize: Size(
                                            double.maxFinite,
                                            45,
                                          ),
                                          side: BorderSide(
                                            color: everyFieldIsSatisfied
                                                ? context.appColorScheme.primary
                                                      .withValues(alpha: .5)
                                                : context
                                                      .appColorScheme
                                                      .onPrimary
                                                      .withValues(alpha: 0.5),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          everyFieldIsSatisfied
                                              ? 'Add To Cart'
                                              : 'Fill The Fields',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
