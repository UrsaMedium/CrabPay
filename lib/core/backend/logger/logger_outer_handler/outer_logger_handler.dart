import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OuterLoggerHandler implements InnerLoggerHandler {
  final String _dsn =
      'https://ea5b1d26b43445a99674a650104b7b51@tracker.regred-rainbowbridge.ru/1';
  @override
  Future<void> init() async {
    await SentryFlutter.init((options) {
      options.dsn = _dsn;
      options.tracesSampleRate = 0.2;
      options.attachScreenshot = true;
    });
  }

  @override
  void logBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category ?? 'ui.action',
        data: data,
      ),
    );
  }

  @override
  void logInfo({required String message, Map<String, dynamic>? meta}) {
    debugPrint(message);
    Sentry.captureMessage(
      message,
      level: SentryLevel.info,
      withScope: (scope) {
        if (meta != null) {
          scope.setContexts('Telemetry Data', meta);
        }
      },
    );
  }

  @override
  void recordException({
    required Object error,
    required StackTrace stackTrace,
  }) {
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  @override
  void clearDiagnosticUser() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  @override
  void setDiagnosticUser({required String id, String? email}) {
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: id, email: email));
    });
  }
}
