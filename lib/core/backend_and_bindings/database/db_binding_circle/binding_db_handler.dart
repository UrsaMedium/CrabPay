import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_outer_circle/outer_database_handler.dart';

class BindingDatabaseHandler implements InnerDatabaseHandler {
  final InnerDatabaseHandler dbHandler;
  BindingDatabaseHandler({required this.dbHandler});

  factory BindingDatabaseHandler.firebasePAP() =>
      BindingDatabaseHandler(dbHandler: (OuterDatabaseHandler()));

  @override
  Future<void> fetchAllProductsAndFieldsData() => dbHandler.fetchAllProductsAndFieldsData();

  // Product
  @override
  Future<void> addProduct(AppProduct product) => dbHandler.addProduct(product);

  @override
  Future<void> deleteProduct(AppProduct product) =>
      dbHandler.deleteProduct(product);

  // Fields
  @override
  Future<void> fetchProductFields(String productId) =>
      dbHandler.fetchProductFields(productId);

  @override
  Future<void> fetchProductField(String id) => dbHandler.fetchProductField(id);

  @override
  Future<void> addProductField(AppProductField field) =>
      dbHandler.addProductField(field);

  @override
  Future<void> deleteProductField(AppProductField field) =>
      dbHandler.deleteProductField(field);

  // Price Function
  @override
  Future<void> fetchPriceFunctions(String productId) =>
      dbHandler.fetchPriceFunctions(productId);

  @override
  Future<void> addPriceFunction(PriceFunction priceFunction) =>
      dbHandler.addPriceFunction(priceFunction);

  @override
  Future<void> deletePriceFunction(PriceFunction priceFunction) =>
      dbHandler.deletePriceFunction(priceFunction);

  // Currencies
  @override
  Future<void> fetchAllCurencies() => dbHandler.fetchAllCurencies();

  @override
  Future<void> addCurrencies(Currencies currencies) =>
      dbHandler.addCurrencies(currencies);

  @override
  Future<void> deleteCurrencies(Currencies currencies) =>
      dbHandler.deleteCurrencies(currencies);
}
