import 'package:crabpay/core/global_language_driver.dart';
import 'package:crabpay/core/set_up/app_bootstrap.dart';
import 'package:crabpay/core/set_up/app_providers.dart';
import 'package:crabpay/core/set_up/theme/app_theme.dart';
import 'package:crabpay/core/app_routes/app_router.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/global_loading_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await AppBootstrap.init();
  runApp(const AppProviders(child: CrabPayApp()));
}

class CrabPayApp extends StatelessWidget {
  const CrabPayApp({super.key});
  @override
  Widget build(BuildContext context) {
    final lang =
        context.select<GlobalLanguageCubit, bool>((cubit) => cubit.state.isRu)
        ? 'ru'
        : 'en';
    final overlayKey = GlobalKey<OverlayState>();
    return SafeArea(
      top: false,
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return MaterialApp.router(
            showPerformanceOverlay: false,
            debugShowCheckedModeBanner: false,
            title: 'CrabPay Demo',
            theme: AppTheme.light(lightDynamic),
            darkTheme: AppTheme.dark(darkDynamic),
            routerConfig: appRouter,
            locale: Locale(lang),
            builder: (context, child) {
              return GlobalLoaderStack(
                child: Overlay(
                  key: overlayKey,
                  initialEntries: [OverlayEntry(builder: (context) => child!)],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
