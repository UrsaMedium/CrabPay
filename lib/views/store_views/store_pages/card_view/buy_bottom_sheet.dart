import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_controller.dart';
import 'package:crabpay/core/buySheetShit/widget_factory.dart';
import 'package:flutter/material.dart';

class BuyBottomSheet extends StatefulWidget {
  final String productId;
  const BuyBottomSheet({super.key, required this.productId});

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  // TextEditingController productId = TextEditingController();
  // TextEditingController order = TextEditingController();
  // TextEditingController propertyName = TextEditingController();
  // TextEditingController handler = TextEditingController();
  // TextEditingController attributesAsString = TextEditingController();
  // TextEditingController dataHandlerAsString = TextEditingController();

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
    PAPDataHandler papDataHandler = PAPDataHandler();
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
          // slivers: [
          //   SliverToBoxAdapter(
          //     child: Column(
          //       children: [
          //         Text('id ${properties[0].id}'),
          //         Text('productId ${properties[0].productId}'),
          //         Text('propertyName ${properties[0].propertyName}'),
          //         Text('handler ${properties[0].handler}'),
          //         Text('order ${properties[0].order}'),
          //         Text('attributes ${properties[0].attributes}'),
          //         Text('dataHandlere ${properties[0].dataHandler}'),
          //       ],
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }
}
