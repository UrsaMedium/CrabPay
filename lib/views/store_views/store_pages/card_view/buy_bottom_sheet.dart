import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:crabpay/core/utilities.dart' show papDataHandler;
import 'package:flutter/material.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  const BuyBottomSheet({super.key, required this.productId});

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  List<Widget> propertySlivers(List<AppProductProperty> properties) {
    properties.sort((a, b) => a.order.compareTo(b.order));
    List<Widget> result = [];
    for (var each in properties) {
      result.add(
        SliverToBoxAdapter(
          child: theAppWidgetBuilder(
            context,
            each.propertyName,
            each.handler,
            each.attributes,
            each.dataHandler,
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<AppProductProperty> properties =
        papDataHandler.productProperties(widget.productId) ?? [];
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: propertySlivers(properties),
        ),
      ),
    );
  }
}
