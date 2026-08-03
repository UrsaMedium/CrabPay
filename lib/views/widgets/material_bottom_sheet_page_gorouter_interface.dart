import 'package:crabpay/core/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';

class BottomSheetPage<T> extends Page<T> {
  final Widget child;
  final bool showDragHandle;
  final bool useSafeArea;
  final bool isScrollControlled;
  final Color? backgroundColor;

  const BottomSheetPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.canPop,
    super.onPopInvoked,
    required this.child,
    this.showDragHandle = false,
    this.useSafeArea = false,
    this.isScrollControlled = true,
    this.backgroundColor,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      builder: (context) => child,
      isScrollControlled: isScrollControlled,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      backgroundColor: context.appColorScheme.surfaceContainer.withValues(
        alpha: context.highGraphics ? .5 : .95,
      ),
      settings: this,
    );
  }
}
