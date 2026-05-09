import 'package:crabpay/core/product_data/product_properties/properties_data_binfing_circle.dart';
import 'package:crabpay/core/product_data/product_properties/properties_data_outer_circle.dart';
import 'package:flutter/material.dart';

class BuyBottomSheet extends StatefulWidget {
  const BuyBottomSheet({super.key});

  @override
  State<BuyBottomSheet> createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  TextEditingController attributesAsString = TextEditingController();
  TextEditingController dataHandlerAsString = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productId,
              decoration: InputDecoration(labelText: 'productId'),
            ),
            TextField(
              controller: order,
              decoration: InputDecoration(labelText: 'order'),
            ),
            TextField(
              controller: propertyName,
              decoration: InputDecoration(labelText: 'propertyName'),
            ),
            TextField(
              controller: handler,
              decoration: InputDecoration(labelText: 'handler'),
            ),
            TextField(
              controller: attributesAsString,
              decoration: InputDecoration(labelText: 'attributes'),
            ),
            TextField(
              controller: dataHandlerAsString,
              decoration: InputDecoration(labelText: 'dataHandler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '' &&
                    attributesAsString.text != '' &&
                    dataHandlerAsString.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributesAsString.text,
                    dataHandlerAsString.text,
                  );
                } else {
                  print('wrong input');
                }
              },
              child: Text('Send'),
            ),
          ],
        ),
      
        // child: CustomScrollView(
        //   slivers: [
        //     SliverToBoxAdapter(
        //       child: Column(
        //         children: [
        //           Text('id ${appProductPropertires[0].id}'),
        //           // Text('productId ${propertiesByProduct(productId)[0].productId}'),
        //           // Text(
        //           //   'propertyName ${propertiesByProduct(productId)[0].propertyName}',
        //           // ),
        //           // Text('handler ${propertiesByProduct(productId)[0].handler}'),
        //           // Text('order ${propertiesByProduct(productId)[0].order}'),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
