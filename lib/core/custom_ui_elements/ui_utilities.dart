import 'package:flutter/material.dart';

const inRadius = 24.0;

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}

const double cornerRadius = 24;
