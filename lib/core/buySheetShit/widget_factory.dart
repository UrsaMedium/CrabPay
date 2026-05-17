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

class WhatWidgetRadio extends StatefulWidget {
  final Map<String, String> radios;
  final String propertyName;
  const WhatWidgetRadio({
    super.key,
    required this.radios,
    required this.propertyName,
  });

  @override
  State<WhatWidgetRadio> createState() => _WhatWidgetRadioState();
}

class _WhatWidgetRadioState extends State<WhatWidgetRadio> {
  late String? _groupValue = '';

  void radioReacts(String? value) {
    setState(() {
      _groupValue = value;
    });
  }

  List<Widget> choices() {
    List<Widget> resultList = [];
    for (final each in widget.radios.keys) {
      resultList.add(
        InkWell(
          onTap: () => radioReacts(widget.radios[each]),
          child: ListTile(
            title: Text(widget.radios[each]!),
            leading: Radio<String>(value: widget.radios[each]!),
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

class WhatWidgetDropdownMenu extends StatefulWidget {
  final Map<String, String> entries;
  final String propertyName;
  const WhatWidgetDropdownMenu({
    super.key,
    required this.entries,
    required this.propertyName,
  });

  @override
  State<WhatWidgetDropdownMenu> createState() => _WhatWidgetDropdownMenuState();
}

class _WhatWidgetDropdownMenuState extends State<WhatWidgetDropdownMenu> {
  final TextEditingController _selectedItem = TextEditingController();
  String selected = '';

  List<DropdownMenuEntry<String>> listOfEntries() {
    List<DropdownMenuEntry<String>> resultList = [];
    for (final each in widget.entries.keys) {
      resultList.add(
        DropdownMenuEntry(value: each, label: widget.entries[each]!),
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

// Returns custom widget based on the recived data:
// - whatItemProperty - requared String - what property of an item, that should be displayd in the item sheet
// - whatItemHandler - requared String - what widget is ment to handel the property data
// - handlerProperties - Map<String, String>? - properties that shapes the handler widget
// - whatData - Map<String, String>? - the data that is ment to be handeled by a widget and retruned

Widget theAppWidgetBuilder(
  BuildContext context,
  String propertyName,
  String handler,
  Map<String, String?>? attributes,
  Map<String, String>? dataHandler,
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
      TextEditingController textFieldController = TextEditingController();
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
                  child: Text(propertyName, style: TextStyle(fontSize: 16)),
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
                controller: textFieldController,
                onChanged: (value) {
                  // appCartItems[handlerProperties?['text'] ?? ''] = textFieldController
                  //     .toString();
                },
              ),
            ),
          ],
        ),
      );
    case 'RadioList': // pass map of option name : option
      return WhatWidgetRadio(
        radios: dataHandler ?? {'error': 'error'},
        propertyName: propertyName,
      );
    case 'DropdownList': // pass map of option name : option
      return WhatWidgetDropdownMenu(
        entries: dataHandler ?? {'error': 'error'},
        propertyName: propertyName,
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
