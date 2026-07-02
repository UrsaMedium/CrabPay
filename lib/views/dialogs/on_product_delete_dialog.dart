import 'package:crabpay/views/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool?> showOnProductDelete(BuildContext context) {
  return showAppGenericDialog(
    context: context,
    title: 'Confirmation',
    message: 'Are you sure you want to delete the product?',
    optionBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((onValue) => onValue ?? false);
}
