import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/logger/logger_outer_handler/outer_logger_handler.dart';

class BindingLoggerHandler implements InnerLoggerHandler {
  final InnerLoggerHandler loggerHandler;

  factory BindingLoggerHandler.logService() =>
      BindingLoggerHandler(loggerHandler: (OuterLoggerHandler()));

  BindingLoggerHandler({required this.loggerHandler});
  @override
  Future<void> init() => loggerHandler.init();

  @override
  void logBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
  }) => loggerHandler.logBreadcrumb(message: message, category: category);

  @override
  void logInfo({required String message, Map<String, dynamic>? meta}) =>
      loggerHandler.logInfo(message: message, meta: meta);

  @override
  void recordException({
    required Object error,
    required StackTrace stackTrace,
  }) => loggerHandler.recordException(error: error, stackTrace: stackTrace);

  @override
  void clearDiagnosticUser() => loggerHandler.clearDiagnosticUser();

  @override
  void setDiagnosticUser({required String id, String? email}) =>
      loggerHandler.setDiagnosticUser(id: id, email: email);
}
