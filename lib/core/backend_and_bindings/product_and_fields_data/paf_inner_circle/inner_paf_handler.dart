import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';

abstract class InnerProductAndFieldsHandler {
  Future<void> fetchAllPAFData();
  //product
  // Future<void> fetchProduct(String id);
  Future<void> addProduct(AppProduct product);
  Future<void> deleteProduct(AppProduct product);
  //fields
  Future<void> fetchProductFields(String productId);
  Future<void> fetchProductField(String id);
  Future<void> addProductField(AppProductField field);
  Future<void> deleteProductField(AppProductField field);
  //price function
  Future<void> fetchPriceFunctions(String productId);
  Future<void> addPriceFunction(PriceFunction priceFunction);
  Future<void> deletePriceFunction(PriceFunction priceFunction);
  //currencies
  Future<void> fetchAllCurencies();
  Future<void> addCurrencies(Currencies currencies);
  Future<void> deleteCurrencies(Currencies currencies);
}
