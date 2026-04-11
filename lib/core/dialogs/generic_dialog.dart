import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef DialogOptionBulder<T> = Map<String, T> Function();

Future<T?> showAppGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String message,
  required DialogOptionBulder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
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
        content: Text(message, textAlign: .center),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return SizedBox(
            width: 100.0,
            child: TextButton(
              onPressed: () {
                if (value != null) {
                  context.pop(value);
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
