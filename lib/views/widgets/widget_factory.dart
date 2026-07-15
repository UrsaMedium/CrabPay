import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

final double blurLevel = 50;

//radio ---------------------------------------------------------------------------------------------------------------------
class RadioConstructor extends StatefulWidget {
  final Function(String, String) collectedDataBridge;
  final List<String> expectedData;
  final String feildName;
  final Map<String, double>? priceImages;
  final bool isCupertino;
  const RadioConstructor({
    super.key,
    required this.expectedData,
    required this.feildName,
    required this.collectedDataBridge,
    this.priceImages,
    required this.isCupertino,
  });

  @override
  State<RadioConstructor> createState() => _RadioConstructorState();
}

class _RadioConstructorState extends State<RadioConstructor> {
  late String? _groupValue = '';

  void radioReacts(String? value) {
    setState(() {
      _groupValue = value;
      widget.collectedDataBridge(widget.feildName, value!);
    });
  }

  List<Widget> choices() {
    List<Widget> resultList = [];
    for (final each in widget.expectedData) {
      resultList.add(
        InkWell(
          onTap: () => radioReacts(each),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(each),
                  leading: Radio<String>(value: each),
                ),
              ),
              if (widget.priceImages != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(widget.priceImages![each].toString()),
                ),
            ],
          ),
        ),
      );
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer.withValues(alpha: .8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: context.appColorScheme.primary.withValues(alpha: .3),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 24,
                right: 24,
                bottom: 0,
              ),
              child: Card(
                elevation: 2,
                color: context.appColorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.feildName, style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
          RadioGroup<String>(
            groupValue: _groupValue,
            onChanged: (value) {
              radioReacts(value);
            },
            child: Column(children: choices()),
          ),
        ],
      ),
    );
  }
}

//dropdown menu ---------------------------------------------------------------------------------------------------------------------
class DropdownMenuConstructor extends StatefulWidget {
  final Function(String, String) collectedDataBridge;
  final List<String> expectedData;
  final String fieldName;
  final bool isCupertino;
  const DropdownMenuConstructor({
    super.key,
    required this.expectedData,
    required this.fieldName,
    required this.collectedDataBridge,
    required this.isCupertino,
  });

  @override
  State<DropdownMenuConstructor> createState() =>
      _DropdownMenuConstructorState();
}

class _DropdownMenuConstructorState extends State<DropdownMenuConstructor> {
  final TextEditingController _selectedItem = TextEditingController();
  String selected = '';

  List<DropdownMenuEntry<String>> listOfEntries() {
    List<DropdownMenuEntry<String>> resultList = [];
    for (final each in widget.expectedData) {
      resultList.add(DropdownMenuEntry(value: each, label: each));
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer.withValues(alpha: .8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),

        side: BorderSide(
          color: context.appColorScheme.primary.withValues(alpha: .3),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                left: 32,
                right: 24,
                bottom: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.fieldName, style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: DropdownMenu<String>(
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: context.appColorScheme.primary,
                    width: 1,
                  ),
                ),
              ),
              onSelected: (value) => setState(() {
                selected = value!;
                widget.collectedDataBridge(widget.fieldName, value);
              }),
              controller: _selectedItem,
              dropdownMenuEntries: listOfEntries(),
            ),
          ),
        ],
      ),
    );
  }
}

//inputField ---------------------------------------------------------------------------------------------------------------------
class InputFieldConstructor extends StatefulWidget {
  final Function(String, String) collectedDataBridge;
  final BuildContext context;
  final String fieldName;
  final List<String> expectedData;
  final bool isCupertino;
  const InputFieldConstructor({
    super.key,
    required this.context,
    required this.fieldName,
    required this.expectedData,
    required this.collectedDataBridge,
    required this.isCupertino,
  });

  @override
  State<InputFieldConstructor> createState() => _InputFieldConstructorState();
}

class _InputFieldConstructorState extends State<InputFieldConstructor> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer.withValues(alpha: .8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: context.appColorScheme.primary.withValues(alpha: .3),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                left: 32,
                right: 24,
                bottom: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(widget.fieldName, style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              controller: _textFieldController,
              onChanged: (value) {
                widget.collectedDataBridge(
                  widget.fieldName,
                  _textFieldController.text.trim(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//appbuilder ---------------------------------------------------------------------------------------------------------------------
Widget theAppWidgetBuilder({
  required Function(String, String) collectedDataBridge,
  required BuildContext context,
  required String fieldName,
  required String handler,
  Map<String, double>? priceImages,
  List<String>? expectedData,
  required bool isCupertino,
}) {
  Map<String, double> pricing = {};
  if (priceImages != null) {
    for (var each in priceImages.keys) {
      pricing[each] = priceImages[each]!;
    }
  }

  switch (handler) {
    case 'InputField': // pass the name of entered data
      return InputFieldConstructor(
        collectedDataBridge: collectedDataBridge,
        context: context,
        fieldName: fieldName,
        expectedData: expectedData ?? ['User data'],
        isCupertino: isCupertino,
      );
    case 'RadioList': // pass map of option name : option
      return RadioConstructor(
        priceImages: priceImages,
        collectedDataBridge: collectedDataBridge,
        expectedData: expectedData ?? ['error'],
        feildName: fieldName,
        isCupertino: isCupertino,
      );
    case 'DropdownList': // pass map of option name : option
      return DropdownMenuConstructor(
        collectedDataBridge: collectedDataBridge,
        expectedData: expectedData ?? ['error'],
        fieldName: fieldName,
        isCupertino: isCupertino,
      );
    default:
      return Text('ERROR');
  }
}
