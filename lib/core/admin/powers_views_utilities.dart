import 'package:crabpay/views/admin_views/admin_powers_views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<String> fontWeights = [
  'thin', // w100
  'extraLight', // w200
  'light', // w300
  'regular', // w400 (Standard)
  'medium', // w500 (Most common for Titles/Labels)
  'semiBold', // w600
  'bold', // w700
  'extraBold', // w800
  'black', // w900
];

List<DropdownMenuEntry<String>> fontWeightsForDropdownMenu() {
  List<DropdownMenuEntry<String>> result = [];
  for (final each in fontWeights) {
    result.add(DropdownMenuEntry(value: each, label: each));
  }
  return result;
}

List<String> fontSizes = [
  '57',
  '45',
  '36',
  '32',
  '28',
  '24',
  '22',
  '16',
  '14',
  '12',
  '11',
];

List<DropdownMenuEntry<String>> fontSizesForDropdownMenu() {
  List<DropdownMenuEntry<String>> result = [];
  for (final each in fontSizes) {
    result.add(DropdownMenuEntry(value: each, label: each));
  }
  return result;
}

List<String> colors = [
  // Primary
  'primary',
  'onPrimary',
  'primaryContainer',
  'onPrimaryContainer',
  'primaryFixed',
  'primaryFixedDim',
  'onPrimaryFixed',
  'onPrimaryFixedVariant',
  // Error
  'error',
  'onError',
  'errorContainer',
  'onErrorContainer',
  // Outlines & Utilities
  'outline',
  'outlineVariant',
  'scrim',
  'shadow',
  'inversePrimary',
];

List<DropdownMenuEntry<String>> colorsForDropdownMenu() {
  List<DropdownMenuEntry<String>> result = [];
  for (final each in colors) {
    result.add(DropdownMenuEntry(value: each, label: each));
  }
  return result;
}

List<String> alignments = [
  'topLeft',
  'topCenter',
  'topRight',
  'centerLeft',
  'center',
  'centerRight',
  'bottomLeft',
  'bottomCenter',
  'bottomRight',
];

List<DropdownMenuEntry<String>> alignmentsForDropdownMenu() {
  List<DropdownMenuEntry<String>> result = [];
  for (final each in alignments) {
    result.add(DropdownMenuEntry(value: each, label: each));
  }
  return result;
}

List<String> widgetHandlers = [
  'Text',
  'InputField',
  'RadioList',
  'DropdownList',
  'divider',
];

List<DropdownMenuEntry<String>> widgetHandlersForDropdownMenu() {
  List<DropdownMenuEntry<String>> result = [];
  for (final each in widgetHandlers) {
    result.add(DropdownMenuEntry(value: each, label: each));
  }
  return result;
}

Map<String, Map<String, dynamic>> adminPowersMap = {
  'Add product': {'route': '/add-product-view', 'widget': ''},
  'Add Text property': {'route': '/add_text_view', 'widget': AddTextProperty()},
  'Add InputField property': {
    'route': '/add_input_field_view',
    'widget': AddInputFieldProperty(),
  },
  'Add RadioList property': {
    'route': '/add_radio_list_view',
    'widget': AddRadioListProperty(),
  },
  'Add DropdownList property': {
    'route': '/add_dropdown_list_view',
    'widget': AddDropdownListProperty(),
  },
  'Add Divider property': {
    'route': '/add_divider_view',
    'widget': AddDividerProperty(),
  },
  'Delete property': {
    'route': '/delete_property_view',
    'widget': DeletePropertyView(),
  },
};

List<Widget> adminPowersButtons(BuildContext context) {
  List<Widget> result = [];
  for (var each in adminPowersMap.keys) {
    result.add(
      ElevatedButton(
        onPressed: () {
          context.go((adminPowersMap[each]!)['route'].toString());
        },
        child: Text(each),
      ),
    );
  }
  return result;
}

List<RouteBase> adminPowerRoutes() {
  List<RouteBase> result = <RouteBase>[];
  for (var each in adminPowersMap.keys) {
    result.add(
      GoRoute(
        path: (adminPowersMap[each]!)['route'].toString(),
        builder: (context, state) => (adminPowersMap[each]!)['widget'],
      ),
    );
  }
  return result;
}
