class ProductField {
  final String id;
  final String productId;
  final int order;
  final String fieldName;
  final String handler;
  final Map<String, String?>? attributes;
  final List<String>? expectedData;

  ProductField({
    required this.id,
    required this.productId,
    required this.order,
    required this.fieldName,
    required this.handler,
    this.attributes,
    this.expectedData,
  });

  factory ProductField.intial() => ProductField(
    id: '',
    productId: '',
    order: 0,
    fieldName: '',
    handler: '',
  );
}
