import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/widgets.dart';

abstract class InnerDatabaseHandler {
  Future<void> fetchAllProducts(BuildContext context);
  //product
  // Future<void> fetchProduct(String id);
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(Product product);
  //fields
  Future<void> fetchProductFields(String productId, BuildContext context);
  Future<void> fetchProductField(String id, BuildContext context);
  Future<void> addProductField(ProductField field);
  Future<void> deleteProductField(ProductField field);
  //price function
  Future<void> fetchPriceFunctions(String productId, BuildContext context);
  Future<void> addPriceFunction(PriceFunction priceFunction);
  Future<void> deletePriceFunction(PriceFunction priceFunction);
  //currencies
  Future<void> fetchAllCurencies(BuildContext context);
  Future<void> addCurrencies(Currencies currencies);
  Future<void> deleteCurrencies(Currencies currencies);
}
