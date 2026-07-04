import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

class GlobalLoadingScreen {
  static final GlobalLoadingScreen _instance = GlobalLoadingScreen._internal();
  factory GlobalLoadingScreen() => _instance;
  GlobalLoadingScreen._internal();

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void show() => isLoading.value = true;
  void hide() => isLoading.value = false;
}

class GlobalLoaderStack extends StatelessWidget {
  final Widget child;

  const GlobalLoaderStack({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder(
          valueListenable: GlobalLoadingScreen().isLoading,
          builder: (context, loading, _) {
            if (!loading) return const SizedBox.shrink();

            return Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: context.appColorScheme.primary,
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.appColorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}