import 'package:flutter/widgets.dart';
import 'package:crabpay/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Fast access to generated localization getters
  AppLocalizations get l10n => AppLocalizations.of(this);
}
