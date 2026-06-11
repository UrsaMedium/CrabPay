class ProductField {
  final String id;
  final String productId;
  final int order;
  final String fieldName;
  bool isPriceImage;
  final String handler;
  Map<String, double>? priceImages;
  final List<String>? expectedData;

  ProductField({
    required this.id,
    required this.productId,
    required this.order,
    required this.fieldName,
    required this.handler,
    this.priceImages,
    this.expectedData,
    required this.isPriceImage,
  });

  set makeThemImage(bool isItThough) => isPriceImage = isItThough;

  set giveImageToAttributes(Map<String, double> pricaImage) => priceImages = pricaImage;

  factory ProductField.intial() => ProductField(
    id: '',
    productId: '',
    order: 0,
    fieldName: '',
    handler: '',
    isPriceImage: false,
  );

}
