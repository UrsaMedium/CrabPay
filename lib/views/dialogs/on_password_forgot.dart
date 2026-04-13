import 'package:crabpay/views/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showOnPasswordResetDialog(BuildContext context) {
  return showAppGenericDialog(
    context: context,
    title: 'Reset Link Sent',
    message: 'Check the email we have sent you to change the password',
    optionBuilder: () => {'OK': null},
  );
}
