import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light(ColorScheme? dynamicLight) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: dynamicLight != null
          ? ColorScheme.fromSeed(
              seedColor: dynamicLight.primary,
              brightness: Brightness.light,
            )
          : ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.light,
            ),
    );
  }

  static ThemeData dark(ColorScheme? dynamicDark) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: dynamicDark != null
          ? ColorScheme.fromSeed(
              seedColor: dynamicDark.primary,
              brightness: Brightness.dark,
            )
          : ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            ),
    );
  }
}
