import 'package:crabpay/core/product_data/cart_items.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

AlignmentGeometry widgetPropertyAlignment(String alignment) {
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

Color widgetPropertyColor(BuildContext context, String color) {
  switch (color) {
    case 'surface':
      return context.appColorScheme.surface;
    default:
      return context.appColorScheme.onSurface;
  }
}

class WhatWidgetRadio extends StatefulWidget {
  final Map<String, String> radios;
  const WhatWidgetRadio({super.key, required this.radios});

  @override
  State<WhatWidgetRadio> createState() => _WhatWidgetRadioState();
}

class _WhatWidgetRadioState extends State<WhatWidgetRadio> {
  late String? _groupValue;

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
    return RadioGroup<String>(
      groupValue: _groupValue,
      onChanged: (value) {
        radioReacts(value);
      },
      child: Column(children: choices()),
    );
  }
}

class WhatWidgetDropdownMenu extends StatefulWidget {
  final Map<String, String> entries;
  const WhatWidgetDropdownMenu({super.key, required this.entries});

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
    return DropdownMenu<String>(
      onSelected: (value) => setState(() {
        selected = value!;
      }),
      controller: _selectedItem,
      dropdownMenuEntries: listOfEntries(),
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
  String whatItemProperty,
  String whatItemHandler,
  Map<String, String>? handlerProperties,
  Map<String, String>? whatData,
) {
  switch (whatItemHandler) {
    case 'Text': // you need to pass: text, alignment, color, fontsize, fontwight
      return Container(
        alignment: widgetPropertyAlignment(
          handlerProperties?['alignment'] ?? 'center',
        ),
        child: Text(
          handlerProperties?['text'] ?? 'no data/',
          style: TextStyle(
            color: widgetPropertyColor(context, handlerProperties?['color'] ?? ''),
            fontSize: double.tryParse(handlerProperties?['fontSize'] ?? '14'),
            fontWeight: FontWeight(
              int.tryParse(handlerProperties?['fontWeight'] ?? '400')!,
            ),
          ),
        ),
      );
    case 'InputField': // pass the name of entered data
      TextEditingController textFieldController = TextEditingController();
      return TextField(
        controller: textFieldController,
        onChanged: (value) {
          appCartItems[handlerProperties?['text'] ?? ''] = textFieldController
              .toString();
        },
      );
    case 'RadioList': // pass map of option name : option
      return WhatWidgetRadio(radios: whatData ?? {'error': 'error'});
    case 'DropdownList': // pass map of option name : option
      return WhatWidgetDropdownMenu(entries: whatData ?? {'error': 'error'});
    default:
      return Text('ERROR');
  }
}
