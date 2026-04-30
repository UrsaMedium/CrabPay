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
            color: widgetPropertyColor(context, widgetProperties['color']!),
            fontSize: double.tryParse(widgetProperties['fontSize'] ?? '14'),
            fontWeight: FontWeight(
              int.tryParse(widgetProperties['fontWeight'] ?? '400') ?? 400,
            ),
          ),
        ),
      );
      case 'TextField':
        TextEditingController textFieldController = TextEditingController();
        return TextField(controller: textFieldController, onChanged: (value) {
           appCartItems[widgetProperties['text'] ?? ''] = textFieldController.toString();
        },);
      case 'radio':

    default:
      return Text('ERROR');
  }
}  