import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/inner_paf_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_outer_circle/outer_paf_handler.dart';

class BindingProductAndFieldsHandler
    implements InnerProductAndFieldsHandler {
  final InnerProductAndFieldsHandler handler;
  BindingProductAndFieldsHandler({required this.handler});

  factory BindingProductAndFieldsHandler.firebasePAP() =>
      BindingProductAndFieldsHandler(
        handler: (OuterProductAndFieldsHandler()),
      );

  @override
  Future<void> addProduct(AppProduct product) => handler.addProduct(product);

  @override
  Future<void> addProductField(AppProductField field) =>
      handler.addProductField(field);

  @override
  Future<void> deleteProduct(AppProduct product) =>
      handler.deleteProduct(product);

  @override
  Future<void> deleteProductField(AppProductField field) =>
      handler.deleteProductField(field);

  @override
  Future<void> fetchAllPAFData() => handler.fetchAllPAFData();
}
