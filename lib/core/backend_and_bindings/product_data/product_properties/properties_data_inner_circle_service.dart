import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/product_properties_model.dart';

abstract class AppProductPropertyHandler {
  Future<List<AppProductProperty>> productPropertiesOfProduct(String productId);
  Future<void> addProductProperty(AppProductProperty productProperty);
  Future<void> deleteProductProperty(AppProductProperty productProperty);
}
