// text, inputfields, radiolist, dropdown list, divider

import 'package:crabpay/core/product_data/product_properties/properties_data_outer_circle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//TEXT
class AddTextProperty extends StatefulWidget {
  const AddTextProperty({super.key});

  @override
  State<AddTextProperty> createState() => _AddTextPropertyState();
}

class _AddTextPropertyState extends State<AddTextProperty> {
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  TextEditingController attributesAsString = TextEditingController();
  TextEditingController dataHandlerAsString = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }
}

//INPUTFIELD
class AddInputFieldProperty extends StatefulWidget {
  const AddInputFieldProperty({super.key});

  @override
  State<AddInputFieldProperty> createState() => _AddInputFieldPropertyState();
}

class _AddInputFieldPropertyState extends State<AddInputFieldProperty> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//RADIOLIST
class AddRadioListProperty extends StatefulWidget {
  const AddRadioListProperty({super.key});

  @override
  State<AddRadioListProperty> createState() => _AddRadioListPropertyState();
}

class _AddRadioListPropertyState extends State<AddRadioListProperty> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//DROPDOWNLIST
class AddDropdownListProperty extends StatefulWidget {
  const AddDropdownListProperty({super.key});

  @override
  State<AddDropdownListProperty> createState() =>
      _AddDropdownListPropertyState();
}

class _AddDropdownListPropertyState extends State<AddDropdownListProperty> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//DIVIDER
class AddDividerProperty extends StatefulWidget {
  const AddDividerProperty({super.key});

  @override
  State<AddDividerProperty> createState() => _AddDividerPropertyState();
}

class _AddDividerPropertyState extends State<AddDividerProperty> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
