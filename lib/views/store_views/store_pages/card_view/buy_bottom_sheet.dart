import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  final List<ProductField> productFields;
  final List<PriceFunction> priceFunctions;
  const BuyBottomSheet({
    super.key,
    required this.productId,
    required this.productFields,
    required this.priceFunctions,
  });

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  Map<String, String> retrievedData = {};
  double precalculatedPrice = 0;

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      retrievedData[fieldName] = dataReceived;
      precalculatedPrice = double.parse(retrievedData.values.first);
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
            attributes: each.attributes,
            expectedData: each.expectedData,
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<ProductField> properties = context
        .read<DatabaseBloc>()
        .state
        .productFields!;
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
                slivers: _propertySlivers(properties),
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
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    height: 50,
                    alignment: .center,
                    padding: .only(left: 16, right: 20),
                    decoration: BoxDecoration(
                      color: context.appColorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                      border: BoxBorder.all(
                        color: context.appColorScheme.outline,
                      ),
                    ),
                    child: Text(
                      '\$$precalculatedPrice',
                      style: TextStyle(color: context.appColorScheme.primary),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
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
