import 'package:crabpay/core/admin/powers_views_utilities.dart';
import 'package:crabpay/core/utilities.dart' show papDataHandler;
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
  TextEditingController order = TextEditingController();
  TextEditingController propertyName = TextEditingController();
  TextEditingController textDisplayed = TextEditingController();
  String productId = '';
  final TextEditingController _selectedProductId = TextEditingController();
  String handler = '';
  final TextEditingController _selectedHandler = TextEditingController();
  String alighment = '';
  final TextEditingController _selectedAlighment = TextEditingController();
  String color = '';
  final TextEditingController _selectedColor = TextEditingController();
  String fontSize = '';
  final TextEditingController _selectedfontSize = TextEditingController();
  String fontWeight = '';
  final TextEditingController _selectedfontWeight = TextEditingController();
  Map<String, String?>? attributes;
  Map<String, String>? dataHandler;

  @override
  Widget build(BuildContext context) {
    final productIdList = papDataHandler.productIdList();
    List<DropdownMenuEntry<String>> productIdForDropDownMenu = [];
    for (var each in productIdList) {
      productIdForDropDownMenu.add(DropdownMenuEntry(value: each, label: each));
    }
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
            //productId
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                productId = value!;
              }),
              controller: _selectedProductId,
              dropdownMenuEntries: productIdForDropDownMenu,
            ),
            //order
            TextField(
              controller: order,
              decoration: InputDecoration(labelText: 'order'),
            ),
            //property name
            TextField(
              controller: propertyName,
              decoration: InputDecoration(labelText: 'propertyName'),
            ),
            //handler
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                handler = value!;
              }),
              controller: _selectedHandler,
              dropdownMenuEntries: widgetHandlersForDropdownMenu(),
            ),
            //text to display
            TextField(
              controller: textDisplayed,
              decoration: InputDecoration(labelText: 'text displayed'),
            ),
            //alignment
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                alighment = value!;
              }),
              controller: _selectedAlighment,
              dropdownMenuEntries: alignmentsForDropdownMenu(),
            ),
            // color
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                color = value!;
              }),
              controller: _selectedColor,
              dropdownMenuEntries: colorsForDropdownMenu(),
            ),
            //font size
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                fontSize = value!;
              }),
              controller: _selectedfontSize,
              dropdownMenuEntries: colorsForDropdownMenu(),
            ),
            //font weight
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                fontWeight = value!;
              }),
              controller: _selectedfontWeight,
              dropdownMenuEntries: fontWeightsForDropdownMenu(),
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     if (productId.text != '' &&
            //         int.tryParse(order.text) != null &&
            //         handler.text != '' &&
            //         propertyName.text != '' &&
            //         textDisplayed.text != '' &&
            //         alighment.text != '' &&
            //         color.text != '' &&
            //         fontSize.text != '' &&
            //         fontWeight.text != '') {
            //       // {"text": "User ID", "alignment": "topLeft", "color": null, "fontSize": null, "fontWeight": null}
            //       attributes = {
            //         'text': textDisplayed.text,
            //         'alignment': alighment.text,
            //         'color': color.text,
            //         'fontSize': fontSize.text,
            //         'fontWeight': fontWeight.text,
            //       };
            //       // '{"text": ${textDisplayed.text}, "alignment": ${alighment.text}, "color": ${color.text}, "fontSize": ${fontSize.text}, "fontWeight": ${fontWeight.text}}';

            //       AppProductProperty toTheOuterSpace = AppProductProperty(
            //         id: 'toTheOuterSpace',
            //         productId: productId.text,
            //         order: int.tryParse(order.text)!,
            //         propertyName: propertyName.text,
            //         handler: handler.text,
            //         attributes: attributes,
            //         dataHandler: dataHandler,
            //       );
            //       // AppProductPropertyHandler.addProductProperty(toTheOuterSpace);
            //     } else {
            //       Fluttertoast.showToast(msg: 'wrong input');
            //     }
            //   },
            //   child: Text('Send'),
            // ),
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
                  // addProperties(
                  //   productId.text,
                  //   int.tryParse(order.text)!,
                  //   handler.text,
                  //   propertyName.text,
                  //   attributes,
                  //   dataHandler.text,
                  // );
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
                  // addProperties(
                  //   productId.text,
                  //   int.tryParse(order.text)!,
                  //   handler.text,
                  //   propertyName.text,
                  //   attributes,
                  //   dataHandler.text,
                  // );
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
                  // addProperties(
                  //   productId.text,
                  //   int.tryParse(order.text)!,
                  //   handler.text,
                  //   propertyName.text,
                  //   attributes,
                  //   dataHandler.text,
                  // );
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
                  // addProperties(
                  //   productId.text,
                  //   int.tryParse(order.text)!,
                  //   handler.text,
                  //   propertyName.text,
                  //   attributes,
                  //   dataHandler,
                  // );
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
