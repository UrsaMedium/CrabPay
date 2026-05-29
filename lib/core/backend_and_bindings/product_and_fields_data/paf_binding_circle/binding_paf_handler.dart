import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/inner_paf_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_outer_circle/outer_paf_handler.dart';

class BindingProductAndFieldsHandler implements InnerProductAndFieldsHandler {
  final InnerProductAndFieldsHandler handler;
  BindingProductAndFieldsHandler({required this.handler});

  factory BindingProductAndFieldsHandler.firebasePAP() =>
      BindingProductAndFieldsHandler(handler: (OuterProductAndFieldsHandler()));

  @override
  Future<void> fetchAllPAFData() => handler.fetchAllPAFData();

  @override
  Future<void> addProduct(AppProduct product) => handler.addProduct(product);

  @override
  Future<void> deleteProduct(AppProduct product) =>
      handler.deleteProduct(product);

  @override
  Future<void> fetchProductField(String id) {
    // TODO: implement fetchProductField
    throw UnimplementedError();
  }

  @override
  Future<void> fetchProductFields(String productId) {
    // TODO: implement fetchProductFields
    throw UnimplementedError();
  }

  @override
  Future<void> addProductField(AppProductField field) =>
      handler.addProductField(field);

  @override
  Future<void> deleteProductField(AppProductField field) =>
      handler.deleteProductField(field);

  @override
  Future<void> fetchPriceFunctions(String productId) {
    // TODO: implement fetchPriceFunctions
    throw UnimplementedError();
  }

  @override
  Future<void> addPriceFunction(PriceFunction priceFunction) {
    // TODO: implement addPriceFunction
    throw UnimplementedError();
  }

  @override
  Future<void> deletePriceFunction(PriceFunction priceFunction) {
    // TODO: implement deletePriceFunction
    throw UnimplementedError();
  }

  @override
  Future<void> fetchAllCurencies() {
    // TODO: implement fetchAllCurencies
    throw UnimplementedError();
  }

  @override
  Future<void> addCurrencies(Currencies currencies) {
    // TODO: implement addCurrencies
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCurrencies(Currencies currencies) {
    // TODO: implement deleteCurrencies
    throw UnimplementedError();
  }
}
