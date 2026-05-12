import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/properties_data_inner_circle_service.dart';
import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/properties_data_outer_circle_service.dart';

class BindingProductPropertyHandler implements AppProductPropertyHandler {
  final AppProductPropertyHandler handler;
  BindingProductPropertyHandler({required this.handler});

  factory BindingProductPropertyHandler.firebaseDataConnect() =>
    BindingProductPropertyHandler(handler: (FirebaseDataConnectProductPropertyHandler()));

  @override
  Future<void> addProductProperty(AppProductProperty productProperty) {
    handler.addProductProperty(productProperty);
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProductProperty(AppProductProperty productProperty) {
    handler.deleteProductProperty(productProperty);
    throw UnimplementedError();
  }

  @override
  Future<List<AppProductProperty>> productPropertiesOfProduct(String productId) {
    handler.productPropertiesOfProduct(productId);
    throw UnimplementedError();
  }
}