import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}