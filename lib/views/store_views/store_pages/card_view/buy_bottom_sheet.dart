import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/cart_bloc/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  void initState() {
    product = context.read<DatabaseBloc>().state.products?.firstWhere(
      (product) => product.id == widget.productId,
    );
    super.initState();
  }

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      double retrievedPrice = 0;
      retrievedData[fieldName] = dataReceived;
      if (fieldName ==
          widget.productFields
              .firstWhere((element) => element.isPriceImage)
              .fieldName) {
        retrievedPrice = widget.productFields
            .firstWhere((element) => element.fieldName == fieldName)
            .priceImages![dataReceived]!;
      }
      precalculatedPrice = retrievedPrice;
    });
  }

  List<Widget> _propertySlivers(List<ProductField> properties) {
    properties.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [];
    for (var each in properties) {
      result.add(
        SliverToBoxAdapter(
          child: theAppWidgetBuilder(
            collectedDataBridge: _onBottomSheetDataRetrieved,
            context: context,
            fieldName: each.fieldName,
            handler: each.handler,
            priceImages: each.priceImages,
            expectedData: each.expectedData,
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: _propertySlivers(widget.productFields),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 32,
              top: 12,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 50,
                    width: 100,
                    alignment: .center,
                    padding: .only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: precalculatedPrice == 0
                          ? context.appColorScheme.surfaceContainerHigh
                          : context.appColorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                      border: BoxBorder.all(
                        color: precalculatedPrice == 0
                            ? context.appColorScheme.surfaceContainerHighest
                            : context.appColorScheme.outline,
                      ),
                    ),
                    child: Text(
                      precalculatedPrice == 0 ? '--' : '\$$precalculatedPrice',
                      overflow: .clip,
                      style: TextStyle(color: context.appColorScheme.primary),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      CartItem cartItem = CartItem(
                        id: 'id',
                        userId: 'mockuser0',
                        userName: 'mocluser',
                        productId: widget.productId,
                        productName: product!.name,
                        purchaseData: retrievedData,
                        currency: widget.currency.name,
                        checkoutPrice: precalculatedPrice,
                        status: 'created',
                      );
                      try {
                        context.read<CartBloc>().add(
                          CartEventAddCartItem(cartItem: cartItem),
                        );
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: 'Bee');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColorScheme.primary,
                      foregroundColor: context.appColorScheme.onPrimary,
                      minimumSize: Size(double.maxFinite, 50),
                    ),

                    child: Text(
                      'Add To Cart',
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
        ],
      ),
    );
  }
}
