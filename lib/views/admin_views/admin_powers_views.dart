import 'package:crabpay/core/admin/powers_views_utilities.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/pap_bloc/pap_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/pap_bloc/pap_event.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/utilities.dart' show papDataHandler;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeletePropertyView extends StatefulWidget {
  const DeletePropertyView({super.key});

  @override
  State<DeletePropertyView> createState() => _DeletePropertyViewState();
}

class _DeletePropertyViewState extends State<DeletePropertyView> {
  String propertyId = '';
  TextEditingController _selectedProductId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final propertiesIdList = papDataHandler.propertiesIdList();
    List<DropdownMenuEntry<String>> propertiesIdForDropDownMenu = [];
    for (var each in propertiesIdList) {
      propertiesIdForDropDownMenu.add(
        DropdownMenuEntry(value: each, label: each),
      );
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownMenu(
              onSelected: (value) => setState(() {
                propertyId = value!;
              }),
              controller: _selectedProductId,
              dropdownMenuEntries: propertiesIdForDropDownMenu,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PapBloc>().add(
                  PapEventDeleteProductProperty(
                    productProperty: papDataHandler.propertyById(propertyId),
                  ),
                );
                context.pop();
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

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
  // String handler = '';
  // final TextEditingController _selectedHandler = TextEditingController();
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
            // DropdownMenu<String>(
            //   onSelected: (value) => setState(() {
            //     handler = value!;
            //   }),
            //   controller: _selectedHandler,
            //   dropdownMenuEntries: widgetHandlersForDropdownMenu(),
            // ),
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
              dropdownMenuEntries: fontSizesForDropdownMenu(),
            ),
            //font weight
            DropdownMenu<String>(
              onSelected: (value) => setState(() {
                fontWeight = value!;
              }),
              controller: _selectedfontWeight,
              dropdownMenuEntries: fontWeightsForDropdownMenu(),
            ),

            ElevatedButton(
              onPressed: () {
                if (order.text != '' &&
                    propertyName.text != '' &&
                    textDisplayed.text != '' &&
                    productId != '') {
                  Map<String, String?>? attributes = {
                    'alignment': alighment,
                    'text': textDisplayed.text,
                    'color': color,
                    'fontSize': fontSize,
                    'fontWeight': fontSize,
                  };
                  AppProductProperty dataInput = AppProductProperty(
                    id: '',
                    productId: productId,
                    order: int.parse(order.text),
                    propertyName: propertyName.text,
                    handler: 'Text',
                    attributes: attributes,
                  );
                  context.read<PapBloc>().add(
                    PapEventAddProductProperty(productProperty: dataInput),
                  );
                }
              },
              child: Text('Push'),
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
            ElevatedButton(onPressed: () {}, child: Text('Push')),
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

            ElevatedButton(onPressed: () {}, child: Text('Push')),
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

            ElevatedButton(onPressed: () {}, child: Text('Push')),
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

            ElevatedButton(onPressed: () {}, child: Text('Push')),
          ],
        ),
      ),
    );
  }
}
