import 'package:crabpay/core/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool?> showOnLoginDialog(BuildContext context) {
  return showAppGenericDialog(
    context: context,
    title: 'Verification Needed',
    message: 'Seems like you have not confirmd your email. There should a verification link in your inbox',
    optionBuilder: () => {
      'Send Again': true,
      'OK': false,
    },
  ).then((onValue) => onValue ?? false);
}
