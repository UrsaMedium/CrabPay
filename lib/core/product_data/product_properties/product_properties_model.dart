class AppProductPropertiers {
  final String id;
  final String productId;
  final int order;
  final String propertyName;
  final String handler;
  final Map<String, String?>? attributes;
  final Map<String, String>? dataHandler;

  AppProductPropertiers({
    required this.id,
    required this.productId,
    required this.order,
    required this.propertyName,
    required this.handler,
    this.attributes,
    this.dataHandler,
  });

  factory AppProductPropertiers.intial() => AppProductPropertiers(
    id: '',
    productId: '',
    order: 0,
    propertyName: '',
    handler: '',
  );
}
