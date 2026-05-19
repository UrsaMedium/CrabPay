import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';

abstract class InnerProductAndFieldsHandler {
  Future<void> fetchAllPAFData();
  Future<void> addProduct(AppProduct product);
  Future<void> deleteProduct(AppProduct product);
  Future<void> addProductField(AppProductField field);
  Future<void> deleteProductField(AppProductField field);
}