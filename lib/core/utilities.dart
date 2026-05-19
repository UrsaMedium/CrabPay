import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_controller.dart'
    show PAFDataHandler;
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/inner_paf_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_outer_circle/outer_paf_handler.dart';
import 'package:flutter/material.dart';

PAFDataHandler papDataHandler = PAFDataHandler();
InnerProductAndFieldsHandler papServerHandler =
    OuterProductAndFieldsHandler();

extension ContextExtensions on BuildContext {
  ColorScheme get appColorScheme => Theme.of(this).colorScheme;
}

//loading
final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
OverlayEntry? _overlayEntry;

void showLoading(BuildContext context) {
  _overlayEntry = OverlayEntry(
    builder: (context) => Container(
      color: context.appColorScheme.onPrimary,
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
  Overlay.of(context).insert(_overlayEntry!);
}

void hideLoading() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}

void showScnackBarMessege(BuildContext context, String messege) {
  // ignore: avoid_print
  print(
    '${messege}_____________________________________________________________________________________________',
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messege),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 200,
        left: 10,
        right: 10,
      ),
    ),
  );
}
