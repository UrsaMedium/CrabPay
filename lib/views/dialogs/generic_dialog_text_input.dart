import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef DialogOptionBulder<T> = Map<String, T> Function();

Future<String?> showOnInputDialog(BuildContext context, String title) {
  return showAppGenericDialogInputText(
    context: context,
    title: title,
    optionBuilder: () => {'Input': true, 'Dismiss': false},
  );
}

Future<String?> showAppGenericDialogInputText<T>({
  required BuildContext context,
  required String title,
  required DialogOptionBulder optionBuilder,
}) {
  TextEditingController typedValue = TextEditingController();
  final options = optionBuilder();
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: context.appColorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: .center,
        ),
        content: TextField(
          controller: typedValue,
          onChanged: (value) => typedValue,
        ),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return SizedBox(
            width: 100.0,
            child: TextButton(
              onPressed: () {
                if (value == true && typedValue.text.trim() != '') {
                  context.pop(typedValue.text);
                } else {
                  context.pop();
                }
              },
              child: Text(optionTitle),
            ),
          );
        }).toList(),
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}
