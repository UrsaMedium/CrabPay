import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';

abstract class InnerDatabaseHandler {
  Future<void> fetchAllProductsAndFieldsData();
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
