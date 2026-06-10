import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  final List<ProductField> productFields;
  const BuyBottomSheet({
    super.key,
    required this.productId,
    required this.productFields,
  });

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  Map<String, String> retrievedData = {};
  double precalculatedPrice = 0;
  List<String> functionDimentions = [];
  double theCoeffitient = 1;

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      // int ifAllGood = 0;
      // retrievedData[fieldName] = dataReceived;
      // for (var formula in widget.priceFunction.fomulas.keys) {
      //   if (Set.from(retrievedData.keys).containsAll(formula)) {
      //     theCoeffitient = widget.priceFunction.fomulas[formula]!;
      //     ifAllGood++;
      //   }
      // }
      // if (ifAllGood == 1) {
      //   if (widget.priceFunction.type == 'linear') {
      //     double? input = double.tryParse(
      //       retrievedData[retrievedData.keys.firstWhere(
      //             (element) =>
      //                 element == widget.priceFunction.functionImageField,
      //           )] ??
      //           'q',
      //     );
      //     if (input != null) {
      //       precalculatedPrice = input * theCoeffitient;
      //     } else {
      //       precalculatedPrice = 0;
      //     }
      //   } else {
      //     precalculatedPrice = theCoeffitient;
      //   }
      // } else {
      //   print('bugger -- $ifAllGood');
      // }
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
