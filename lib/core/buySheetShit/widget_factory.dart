import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

AlignmentGeometry widgetPropertyAlignment(String? alignment) {
  switch (alignment) {
    case 'topLeft':
      return Alignment.topLeft;
    case 'topCenter':
      return Alignment.topCenter;
    case 'topRight':
      return Alignment.topRight;
    case 'centerLeft':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'centerRight':
      return Alignment.centerRight;
    case 'bottomLeft':
      return Alignment.bottomLeft;
    case 'bottomCenter':
      return Alignment.bottomCenter;
    case 'bottomRight':
      return Alignment.bottomRight;
    default:
      return Alignment.center;
  }
}

Color widgetPropertyColor(BuildContext context, String? color) {
  switch (color) {
    case 'surface':
      return context.appColorScheme.surface;
    default:
      return context.appColorScheme.onSurface;
  }
}

class RadioConstructor extends StatefulWidget {
  final List<String> expectedData;
  final String propertyName;
  const RadioConstructor({
    super.key,
    required this.expectedData,
    required this.propertyName,
  });

  @override
  State<RadioConstructor> createState() => _RadioConstructorState();
}

class _RadioConstructorState extends State<RadioConstructor> {
  late String? _groupValue = '';

  void radioReacts(String? value) {
    setState(() {
      _groupValue = value;
    });
  }

  List<Widget> choices() {
    List<Widget> resultList = [];
    for (final each in widget.expectedData) {
      resultList.add(
        InkWell(
          onTap: () => radioReacts(each),
          child: ListTile(
            title: Text(each),
            leading: Radio<String>(value: each),
          ),
        ),
      );
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),

        // side: BorderSide(color: context.appColorScheme.primary)
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
                  child: Text(
                    widget.propertyName,
                    style: TextStyle(fontSize: 16),
                  ),
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

class DropdownMenuConstructor extends StatefulWidget {
  final List<String> expectedData;
  final String propertyName;
  const DropdownMenuConstructor({
    super.key,
    required this.expectedData,
    required this.propertyName,
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
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),

        // side: BorderSide(color: context.appColorScheme.primary)
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
                child: Text(
                  widget.propertyName,
                  style: TextStyle(fontSize: 16),
                ),
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

class InputFieldConstructor extends StatefulWidget {
  final Function(String, String) dataBridge;
  final BuildContext context;
  final String fieldName;
  final List<String> expectedData;
  const InputFieldConstructor({
    super.key,
    required this.context,
    required this.fieldName,
    required this.expectedData,
    required this.dataBridge,
  });

  @override
  State<InputFieldConstructor> createState() => _InputFieldConstructorState();
}

class _InputFieldConstructorState extends State<InputFieldConstructor> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Map<String, String> dataHandler = widget.dataHandler;
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      color: context.appColorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),

        // side: BorderSide(color: context.appColorScheme.primary)
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
                widget.dataBridge(widget.fieldName, _textFieldController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget theAppWidgetBuilder(
  Function(String, String) dataBridge,
  BuildContext context,
  String fieldName,
  String handler,
  Map<String, String?>? attributes,
  List<String>? expectedData,
) {
  Map<String, String> attr = {};
  if (attributes != null) {
    for (var each in attributes.keys) {
      if (attributes[each] == '') {
        attr[each] = 'null';
      } else {
        attr[each] = attributes[each]!;
      }
    }
  }

  switch (handler) {
    case 'Text': // you need to pass: text, alignment, color, fontsize, fontwight
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16),
        child: Container(
          alignment: widgetPropertyAlignment(attr['alignment']),
          child: Text(
            attr['text']!,
            style: TextStyle(
              color: widgetPropertyColor(context, attr['color']),
              fontSize: double.tryParse(attr['fontSize']!) ?? 14,
              fontWeight: FontWeight(int.tryParse(attr['fontWeight']!) ?? 400),
            ),
          ),
        ),
      );
    case 'InputField': // pass the name of entered data
      return InputFieldConstructor(
        dataBridge: dataBridge,
        context: context,
        fieldName: fieldName,
        expectedData: expectedData ?? ['user custom input'],
      );
    case 'RadioList': // pass map of option name : option
      return RadioConstructor(
        expectedData: expectedData ?? ['user custom input'],
        propertyName: fieldName,
      );
    case 'DropdownList': // pass map of option name : option
      return DropdownMenuConstructor(
        expectedData: expectedData ?? ['user custom input'],
        propertyName: fieldName,
      );
    case 'Divider':
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Divider(),
      );
    default:
      return Text('ERROR');
  }
}
