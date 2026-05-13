import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';

abstract class InnerProductAndPropertiesHandler {
  Future<void> fetchAllPAPData();
  Future<void> addProduct(AppProduct product);
  Future<void> deleteProduct(AppProduct product);
  Future<void> addProductProperty(AppProductProperty property);
  Future<void> deleteProductProperty(AppProductProperty property);
}