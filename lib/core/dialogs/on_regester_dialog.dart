import 'package:crabpay/core/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showOnRegisterDialog(BuildContext context) {
  return showAppGenericDialog(
    context: context,
    title: 'Verification Needed',
    message: 'We have sent you the verification link to your email',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
