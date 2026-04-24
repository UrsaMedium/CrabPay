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

Widget theAppWidgetBuilder(
  String whatWidget,
  Map<String, String> widgetProperties,
) {
  switch (whatWidget) {
    case 'Text': // you need to pass:
      return Container(
        alignment: widgetPropertyAlignment(widgetProperties['alignment'] ?? 'center'),
        child: Text(widgetProperties['text'] ?? 'no data/'),
      );
    default:
      return Text('ERROR');
  }
}
