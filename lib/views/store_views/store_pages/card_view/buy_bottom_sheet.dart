import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart'
    show ContextExtensions, papDataHandler;
import 'package:flutter/material.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  const BuyBottomSheet({super.key, required this.productId});

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  Map<String, String> retrievedData = {};

  void _onBottomSheetDataRetrieved(String fieldName, String dataReceived) {
    setState(() {
      retrievedData[fieldName] = dataReceived;
    });
  }

  List<Widget> _propertySlivers(List<AppProductField> properties) {
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
    List<AppProductField> properties =
        papDataHandler.productFields(widget.productId) ?? [];
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
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColorScheme.primary,
                foregroundColor: context.appColorScheme.onPrimary,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Add To Cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
