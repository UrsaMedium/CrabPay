import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/inner_pap_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_outer_circle/outer_pap_handler.dart';

class BindingProductAndPropertiesHandler
    implements InnerProductAndPropertiesHandler {
  final InnerProductAndPropertiesHandler handler;
  BindingProductAndPropertiesHandler({required this.handler});

  factory BindingProductAndPropertiesHandler.firebasePAP() =>
      BindingProductAndPropertiesHandler(
        handler: (OuterProductAndPropertiesHandler()),
      );

  @override
  Future<void> addProduct(AppProduct product) => handler.addProduct(product);

  @override
  Future<void> addProductProperty(AppProductProperty property) =>
      handler.addProductProperty(property);

  @override
  Future<void> deleteProduct(AppProduct product) =>
      handler.deleteProduct(product);

  @override
  Future<void> deleteProductProperty(AppProductProperty property) =>
      handler.deleteProductProperty(property);

  @override
  Future<void> fetchAllPAPData() => handler.fetchAllPAPData();
}
