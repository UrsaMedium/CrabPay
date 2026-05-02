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
  String _groupValue = 'roo';

  void radioReacts(String? value) {
    setState(() {
      _groupValue = value ?? 'err';
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

Widget theAppWidgetBuilder(
  BuildContext context,
  String whatWidget,
  Map<String, String> widgetProperties,
) {
  switch (whatWidget) {
    case 'Text': // you need to pass: text, alignment, color, fontsize, fontwight
      return Container(
        alignment: widgetPropertyAlignment(
          widgetProperties['alignment'] ?? 'center',
        ),
        child: Text(
          widgetProperties['text'] ?? 'no data/',
          style: TextStyle(
            color: widgetPropertyColor(context, widgetProperties['color'] ?? ''),
            fontSize: double.tryParse(widgetProperties['fontSize'] ?? '14'),
            fontWeight: FontWeight(
              int.tryParse(widgetProperties['fontWeight'] ?? '400')!,
            ),
          ),
        ),
      );
    case 'TextField':
      TextEditingController textFieldController = TextEditingController();
      return TextField(
        controller: textFieldController,
        onChanged: (value) {
          appCartItems[widgetProperties['text'] ?? ''] = textFieldController
              .toString();
        },
      );
    case 'radio':
      return WhatWidgetRadio(radios: widgetProperties);
    case 'DropdownMenu':
      return WhatWidgetDropdownMenu(entries: widgetProperties);
    default:
      return Text('ERROR');
  }
}
