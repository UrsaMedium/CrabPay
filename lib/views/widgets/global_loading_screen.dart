import 'package:crabpay/core/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalLoadingScreen {
  static final GlobalLoadingScreen _instance = GlobalLoadingScreen._internal();
  factory GlobalLoadingScreen() => _instance;
  GlobalLoadingScreen._internal();

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  void show() {
    print('loading is called');
    if (_isLoading.value) return;

    _isLoading.value = true;
  }

  void hide() {
    print('hiding is called');
    if (!_isLoading.value) return;

    _isLoading.value = false;
  }
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
          valueListenable: GlobalLoadingScreen()._isLoading,
          builder: (context, loading, _) {
            if (!loading) return const SizedBox.shrink();

            return Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: context.appColorScheme.primary,
                ),
                Center(
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator(
                          color: context.appColorScheme.onPrimary,
                        )
                      : CircularProgressIndicator(
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
