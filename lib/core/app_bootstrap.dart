import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/supabase/supabase_conf.dart';
import 'package:crabpay/core/get_it.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBootstrap {
  static Future<void> init() async {
    SentryWidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: supabaseAccessConf['url']!,
      publishableKey: supabaseAccessConf['publishableKey']!,
    );
    await AppLocalStorage.init();
    setupDependencies();
    await getIt<InnerLoggerHandler>().init();

    // FlutterError.onError = (FlutterErrorDetails details) {
    //   getIt<InnerLoggerHandler>().recordException(
    //     error: details,
    //     stackTrace: details.stack ?? StackTrace.empty,
    //   );
    // };

    // PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    //   getIt<InnerLoggerHandler>().recordException(
    //     error: error,
    //     stackTrace: stack,
    //   );
    //   return true;
    // };

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }
}
