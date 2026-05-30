import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_outer_circle/outer_database_handler.dart';
import 'package:flutter/widgets.dart';

class BindingDatabaseHandler implements InnerDatabaseHandler {
  final InnerDatabaseHandler dbHandler;
  BindingDatabaseHandler({required this.dbHandler});

  factory BindingDatabaseHandler.firebasePAP() =>
      BindingDatabaseHandler(dbHandler: (OuterDatabaseHandler()));

  @override
  Future<void> fetchAllProducts(BuildContext context) =>
      dbHandler.fetchAllProducts(context);

  // Product
  @override
  Future<void> addProduct(Product product) => dbHandler.addProduct(product);

  @override
  Future<void> deleteProduct(Product product) =>
      dbHandler.deleteProduct(product);

  // Fields
  @override
  Future<void> fetchProductFields(String productId, BuildContext context) =>
      dbHandler.fetchProductFields(productId, context);

  @override
  Future<void> fetchProductField(String id, BuildContext context) =>
      dbHandler.fetchProductField(id, context);

  @override
  Future<void> addProductField(ProductField field) =>
      dbHandler.addProductField(field);

  @override
  Future<void> deleteProductField(ProductField field) =>
      dbHandler.deleteProductField(field);

  // Price Function
  @override
  Future<void> fetchPriceFunctions(String productId, BuildContext context) =>
      dbHandler.fetchPriceFunctions(productId, context);

  @override
  Future<void> addPriceFunction(PriceFunction priceFunction) =>
      dbHandler.addPriceFunction(priceFunction);

  @override
  Future<void> deletePriceFunction(PriceFunction priceFunction) =>
      dbHandler.deletePriceFunction(priceFunction);

  // Currencies
  @override
  Future<void> fetchAllCurencies(BuildContext context) =>
      dbHandler.fetchAllCurencies(context);

  @override
  Future<void> addCurrencies(Currencies currencies) =>
      dbHandler.addCurrencies(currencies);

  @override
  Future<void> deleteCurrencies(Currencies currencies) =>
      dbHandler.deleteCurrencies(currencies);
}
