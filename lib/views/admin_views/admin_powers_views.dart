// import 'package:crabpay/core/admin/powers_views_utilities.dart';
// import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/paf_bloc/paf_bloc.dart';
// import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/paf_bloc/paf_event.dart';
// import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
// import 'package:crabpay/core/utilities.dart' show papDataHandler;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class DeletePropertyView extends StatefulWidget {
//   const DeletePropertyView({super.key});

//   @override
//   State<DeletePropertyView> createState() => _DeletePropertyViewState();
// }

// class _DeletePropertyViewState extends State<DeletePropertyView> {
//   String propertyId = '';
//   final TextEditingController _selectedProductId = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final propertiesIdList = papDataHandler.fieldsIdList();
//     List<DropdownMenuEntry<String>> propertiesIdForDropDownMenu = [];
//     for (var each in propertiesIdList) {
//       propertiesIdForDropDownMenu.add(
//         DropdownMenuEntry(value: each, label: each),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             if (GoRouter.of(context).canPop()) {
//               context.pop();
//             }
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             DropdownMenu(
//               onSelected: (value) => setState(() {
//                 propertyId = value!;
//               }),
//               controller: _selectedProductId,
//               dropdownMenuEntries: propertiesIdForDropDownMenu,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<PafBloc>().add(
//                   PafEventDeleteProductField(
//                     productField: papDataHandler.fieldById(propertyId),
//                   ),
//                 );
//                 if (GoRouter.of(context).canPop()) {
//                   context.pop();
//                 }
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //TEXT
// class AddTextProperty extends StatefulWidget {
//   const AddTextProperty({super.key});

//   @override
//   State<AddTextProperty> createState() => _AddTextPropertyState();
// }

// class _AddTextPropertyState extends State<AddTextProperty> {
//   String productId = '';
//   final TextEditingController _selectedProductId = TextEditingController();
//   List<DropdownMenuEntry<String>> productIdForDropDownMenu =
//       productIdListForDropDownMenu();
//   TextEditingController order = TextEditingController();
//   TextEditingController propertyName = TextEditingController();
//   Map<String, String?>? attributes;
//   Map<String, String>? dataHandler;
//   //the rest
//   TextEditingController textDisplayed = TextEditingController();
//   String alighment = '';
//   final TextEditingController _selectedAlighment = TextEditingController();
//   String color = '';
//   final TextEditingController _selectedColor = TextEditingController();
//   String fontSize = '';
//   final TextEditingController _selectedfontSize = TextEditingController();
//   String fontWeight = '';
//   final TextEditingController _selectedfontWeight = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             if (GoRouter.of(context).canPop()) {
//               context.pop();
//             }
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //productId
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 productId = value!;
//               }),
//               controller: _selectedProductId,
//               dropdownMenuEntries: productIdForDropDownMenu,
//             ),
//             //order
//             TextField(
//               controller: order,
//               decoration: InputDecoration(labelText: 'order'),
//             ),
//             //property name
//             TextField(
//               controller: propertyName,
//               decoration: InputDecoration(labelText: 'propertyName'),
//             ),
//             //text displayed
//             TextField(
//               controller: textDisplayed,
//               decoration: InputDecoration(labelText: 'text displayed'),
//             ),
//             //alignment
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 alighment = value!;
//               }),
//               controller: _selectedAlighment,
//               dropdownMenuEntries: alignmentsForDropdownMenu(),
//             ),
//             // color
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 color = value!;
//               }),
//               controller: _selectedColor,
//               dropdownMenuEntries: colorsForDropdownMenu(),
//             ),
//             //font size
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 fontSize = value!;
//               }),
//               controller: _selectedfontSize,
//               dropdownMenuEntries: fontSizesForDropdownMenu(),
//             ),
//             //font weight
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 fontWeight = value!;
//               }),
//               controller: _selectedfontWeight,
//               dropdownMenuEntries: fontWeightsForDropdownMenu(),
//             ),

//             ElevatedButton(
//               onPressed: () {
//                 if (order.text != '' &&
//                     propertyName.text != '' &&
//                     textDisplayed.text != '' &&
//                     productId != '') {
//                   Map<String, String?>? attributes = {
//                     'alignment': alighment,
//                     'text': textDisplayed.text,
//                     'color': color,
//                     'fontSize': fontSize,
//                     'fontWeight': fontSize,
//                   };
//                   AppProductField dataInput = AppProductField(
//                     id: '',
//                     productId: productId,
//                     order: int.parse(order.text),
//                     fieldName: propertyName.text,
//                     handler: 'Text',
//                     attributes: attributes,
//                   );
//                   context.read<PafBloc>().add(
//                     PafEventAddProductField(productField: dataInput),
//                   );
//                   if (GoRouter.of(context).canPop()) {
//                     context.pop();
//                   }
//                 }
//               },
//               child: Text('Push'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //DROPDOWNLIST OR RADIOLIST
// class AddDropdownOrRadioProperty extends StatefulWidget {
//   const AddDropdownOrRadioProperty({super.key});

//   @override
//   State<AddDropdownOrRadioProperty> createState() =>
//       _AddDropdownOrRadioPropertyState();
// }

// class _AddDropdownOrRadioPropertyState
//     extends State<AddDropdownOrRadioProperty> {
//   TextEditingController order = TextEditingController();
//   TextEditingController propertyName = TextEditingController();
//   String productId = '';
//   final TextEditingController _selectedProductId = TextEditingController();
//   List<DropdownMenuEntry<String>> productIdForDropDownMenu =
//       productIdListForDropDownMenu();
//   Map<String, String?>? attributes;
//   List<String>? dataHandler;
//   //the rest
//   TextEditingController dataHandlerText = TextEditingController();
//   final TextEditingController _selectedHandler = TextEditingController();
//   String handler = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             if (GoRouter.of(context).canPop()) {
//               context.pop();
//             }
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //productId
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 productId = value!;
//               }),
//               controller: _selectedProductId,
//               dropdownMenuEntries: productIdForDropDownMenu,
//             ),
//             //handler
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 handler = value!;
//               }),
//               controller: _selectedHandler,
//               dropdownMenuEntries: <DropdownMenuEntry<String>>[
//                 DropdownMenuEntry(value: 'RadioList', label: 'RadioList'),
//                 DropdownMenuEntry(value: 'DropdownList', label: 'DropdownList'),
//               ],
//             ),
//             //order
//             TextField(
//               controller: order,
//               decoration: InputDecoration(labelText: 'order'),
//             ),
//             //property name
//             TextField(
//               controller: propertyName,
//               decoration: InputDecoration(labelText: 'propertyName'),
//             ),
//             //datahandler
//             TextField(
//               controller: dataHandlerText,
//               decoration: InputDecoration(labelText: 'dataHandler'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (order.text != '' &&
//                     propertyName.text != '' &&
//                     productId != '') {
//                   List<String> data = dataHandlerText.text
//                       .split(',')
//                       .map((e) => e.trim())
//                       .toList();
//                   dataHandler = [];
//                   for (var each in data) {
//                     dataHandler![each] = each;
//                   }
//                   AppProductField dataInput = AppProductField(
//                     id: '',
//                     productId: productId,
//                     order: int.parse(order.text),
//                     fieldName: propertyName.text,
//                     handler: handler,
//                     expectedData: dataHandler,
//                   );
//                   context.read<PafBloc>().add(
//                     PafEventAddProductField(productField: dataInput),
//                   );
//                   if (GoRouter.of(context).canPop()) {
//                     context.pop();
//                   }
//                 }
//               },
//               child: Text('Push'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //inputfield
// class AddInputFieldProperty extends StatefulWidget {
//   const AddInputFieldProperty({super.key});

//   @override
//   State<AddInputFieldProperty> createState() => _AddInputFieldPropertyState();
// }

// class _AddInputFieldPropertyState extends State<AddInputFieldProperty> {
//   TextEditingController order = TextEditingController();
//   TextEditingController propertyName = TextEditingController();
//   String productId = '';
//   final TextEditingController _selectedProductId = TextEditingController();
//   List<DropdownMenuEntry<String>> productIdForDropDownMenu =
//       productIdListForDropDownMenu();
//   Map<String, String?>? attributes;
//   Map<String, String>? dataHandler;
//   //the rest
//   TextEditingController textFieldData = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             if (GoRouter.of(context).canPop()) {
//               context.pop();
//             }
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //productId
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 productId = value!;
//               }),
//               controller: _selectedProductId,
//               dropdownMenuEntries: productIdForDropDownMenu,
//             ),
//             //order
//             TextField(
//               controller: order,
//               decoration: InputDecoration(labelText: 'order'),
//             ),
//             //property name
//             TextField(
//               controller: propertyName,
//               decoration: InputDecoration(labelText: 'propertyName'),
//             ),
//             TextField(
//               controller: textFieldData,
//               decoration: InputDecoration(
//                 labelText: 'Name the textFieldInputData',
//               ),
//             ),

//             ElevatedButton(
//               onPressed: () {
//                 if (order.text != '' &&
//                     propertyName.text != '' &&
//                     productId != '') {
//                   AppProductField dataInput = AppProductField(
//                     id: '',
//                     productId: productId,
//                     order: int.parse(order.text),
//                     fieldName: propertyName.text,
//                     handler: 'InputField',
//                     expectedData: {'textFieldInputData': textFieldData.text},
//                   );
//                   context.read<PafBloc>().add(
//                     PafEventAddProductField(productField: dataInput),
//                   );
//                   if (GoRouter.of(context).canPop()) {
//                     context.pop();
//                   }
//                 }
//               },
//               child: Text('Push'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //DIVIDER
// class AddDividerProperty extends StatefulWidget {
//   const AddDividerProperty({super.key});

//   @override
//   State<AddDividerProperty> createState() => _AddDividerPropertyState();
// }

// class _AddDividerPropertyState extends State<AddDividerProperty> {
//   TextEditingController order = TextEditingController();
//   TextEditingController propertyName = TextEditingController();
//   String productId = '';
//   final TextEditingController _selectedProductId = TextEditingController();
//   List<DropdownMenuEntry<String>> productIdForDropDownMenu =
//       productIdListForDropDownMenu();
//   Map<String, String?>? attributes;
//   Map<String, String>? dataHandler;
//   //the rest

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             if (GoRouter.of(context).canPop()) {
//               context.pop();
//             }
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //productId
//             DropdownMenu<String>(
//               onSelected: (value) => setState(() {
//                 productId = value!;
//               }),
//               controller: _selectedProductId,
//               dropdownMenuEntries: productIdForDropDownMenu,
//             ),
//             //order
//             TextField(
//               controller: order,
//               decoration: InputDecoration(labelText: 'order'),
//             ),
//             //property name
//             TextField(
//               controller: propertyName,
//               decoration: InputDecoration(labelText: 'propertyName'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (order.text != '' &&
//                     propertyName.text != '' &&
//                     productId != '') {
//                   AppProductField dataInput = AppProductField(
//                     id: '',
//                     productId: productId,
//                     order: int.parse(order.text),
//                     fieldName: propertyName.text,
//                     handler: 'Divider',
//                   );
//                   context.read<PafBloc>().add(
//                     PafEventAddProductField(productField: dataInput),
//                   );
//                   if (GoRouter.of(context).canPop()) {
//                     context.pop();
//                   }
//                 }
//               },
//               child: Text('Push'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
