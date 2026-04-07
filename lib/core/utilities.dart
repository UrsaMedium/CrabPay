import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}

Widget appBigElevatedButton({
  required String text,
  required BuildContext context,
  bool? isPrimary,
}) {
  if (isPrimary == true || isPrimary == null) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: context.appColorScheme.primary,
        foregroundColor: context.appColorScheme.onPrimary,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Submit',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  } else {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
      child: Text(
        text.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
