import 'package:crabpay/core/set_up/app_bootstrap.dart';
import 'package:crabpay/core/set_up/app_providers.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/set_up/theme/app_theme.dart';
import 'package:crabpay/core/app_routes/app_router.dart';
import 'package:crabpay/views/custom_ui_elements/widgets/global_loading_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await AppBootstrap.init();
  runApp(const AppProviders(child: CrabPayApp()));
}

class CrabPayApp extends StatelessWidget {
  const CrabPayApp({super.key});
  @override
  Widget build(BuildContext context) {
    final overlayKey = GlobalKey<OverlayState>();
    getIt<InnerLoggerHandler>().logBreadcrumb(message: 'CrabPayApp build');
    return SafeArea(
      top: false,
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return MaterialApp.router(
            // showPerformanceOverlay: true,
            debugShowCheckedModeBanner: false,
            title: 'CrabPay Demo',
            theme: AppTheme.light(lightDynamic),
            darkTheme: AppTheme.dark(darkDynamic),
            routerConfig: appRouter,
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
