import 'package:crabpay/core/product_data/product_properties/properties_data_outer_circle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController textDisplayed = TextEditingController();
  TextEditingController alighment = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController fontSize = TextEditingController();
  TextEditingController fontWeight = TextEditingController();
  String attributes = 'null';
  String dataHandler = 'null';

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
              controller: textDisplayed,
              decoration: InputDecoration(labelText: 'text displayed'),
            ),
            TextField(
              controller: alighment,
              decoration: InputDecoration(labelText: 'alignment'),
            ),
            TextField(
              controller: color,
              decoration: InputDecoration(labelText: 'color'),
            ),
            TextField(
              controller: fontSize,
              decoration: InputDecoration(labelText: 'fontSize'),
            ),
            TextField(
              controller: fontWeight,
              decoration: InputDecoration(labelText: 'fontWeight'),
            ),

            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '' &&
                    textDisplayed.text != '' &&
                    alighment.text != '' &&
                    color.text != '' &&
                    fontSize.text != '' &&
                    fontWeight.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  attributes =
                      '{"text": ${textDisplayed.text}, "alignment": ${alighment.text}, "color": ${color.text}, "fontSize": ${fontSize.text}, "fontWeight": ${fontWeight.text}}';
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributes,
                    dataHandler,
                  );
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
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
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  String attributes = 'null';
  TextEditingController dataHandler = TextEditingController();

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
              controller: dataHandler,
              decoration: InputDecoration(labelText: 'dataHandler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributes,
                    dataHandler.text,
                  );
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
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

//RADIOLIST
class AddRadioListProperty extends StatefulWidget {
  const AddRadioListProperty({super.key});

  @override
  State<AddRadioListProperty> createState() => _AddRadioListPropertyState();
}

class _AddRadioListPropertyState extends State<AddRadioListProperty> {
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  String attributes = 'null';
  TextEditingController dataHandler = TextEditingController();

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
              controller: dataHandler,
              decoration: InputDecoration(labelText: 'dataHandler'),
            ),

            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributes,
                    dataHandler.text,
                  );
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
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

//DROPDOWNLIST
class AddDropdownListProperty extends StatefulWidget {
  const AddDropdownListProperty({super.key});

  @override
  State<AddDropdownListProperty> createState() =>
      _AddDropdownListPropertyState();
}

class _AddDropdownListPropertyState extends State<AddDropdownListProperty> {
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  String attributes = 'null';
  TextEditingController dataHandler = TextEditingController();

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
              controller: dataHandler,
              decoration: InputDecoration(labelText: 'dataHandler'),
            ),

            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributes,
                    dataHandler.text,
                  );
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
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

//DIVIDER
class AddDividerProperty extends StatefulWidget {
  const AddDividerProperty({super.key});

  @override
  State<AddDividerProperty> createState() => _AddDividerPropertyState();
}

class _AddDividerPropertyState extends State<AddDividerProperty> {
  TextEditingController productId = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController handler = TextEditingController();
  String attributes = 'null';
  String dataHandler = 'null';

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

            ElevatedButton(
              onPressed: () {
                if (productId.text != '' &&
                    int.tryParse(order.text) != null &&
                    handler.text != '' &&
                    propertyName.text != '') {
                  // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
                  addProperties(
                    productId.text,
                    int.tryParse(order.text)!,
                    handler.text,
                    propertyName.text,
                    attributes,
                    dataHandler,
                  );
                } else {
                  Fluttertoast.showToast(msg: 'wrong input');
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
