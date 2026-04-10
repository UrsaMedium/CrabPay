import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

Widget appDialog(BuildContext context, String messege) {
  return Dialog(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(messege),
          TextButton(
            onPressed: () => context.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

void showScnackBarMessege(BuildContext context, String messege) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(messege),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        left: 10,
        right: 10,
      ),
    ),
  );
}
