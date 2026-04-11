import 'package:crabpay/core/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showOnPasswordResetDialog(BuildContext context) {
  return showAppGenericDialog(
    context: context,
    title: 'Reset Link Sent',
    message: 'Check the email wa have sent to change the password',
    optionBuilder: () => {'OK': null},
  );
}
