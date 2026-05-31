import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';

abstract class InnerDatabaseHandler {
  Future<List<Product>?> fetchAllProducts();
  //product
  // Future<void> fetchProduct(String id);
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(Product product);
  //fields
  Future<List<ProductField>?> fetchProductFields(String productId);
  Future<void> fetchProductField(String id); // TODO
  Future<void> addProductField(ProductField field);
  Future<void> deleteProductField(ProductField field);
  //price function
  Future<List<PriceFunction>?> fetchPriceFunctions(String productId);
  Future<void> addPriceFunction(PriceFunction priceFunction);
  Future<void> deletePriceFunction(PriceFunction priceFunction);
  //currencies
  Future<List<Currencies>?> fetchAllCurencies();
  Future<void> addCurrencies(Currencies currencies);
  Future<void> deleteCurrencies(Currencies currencies);
}
