abstract class InnerLoggerHandler {
  Future<void> init();
  void logInfo({required String message, Map<String, dynamic>? meta});
  void logBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
  });
  void recordException({required Object error, required StackTrace stackTrace});
  void setDiagnosticUser({required String id, String? email});
  void clearDiagnosticUser();
}
