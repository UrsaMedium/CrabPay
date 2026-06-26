import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_outer_circle/outer_database_handler.dart';

class BindingDatabaseHandler implements InnerDatabaseHandler {
  final InnerDatabaseHandler dbHandler;
  BindingDatabaseHandler({required this.dbHandler});

  factory BindingDatabaseHandler.firebaseDb() =>
      BindingDatabaseHandler(dbHandler: (OuterDatabaseHandler()));

  @override
  Future<List<Product>?> fetchAllProducts() => dbHandler.fetchAllProducts();

  // Product
  @override
  Future<void> addProduct(Product product) => dbHandler.addProduct(product);

  @override
  Future<void> deleteProduct(Product product) =>
      dbHandler.deleteProduct(product);

  // Fields
  @override
  Future<List<ProductField>?> fetchProductFields(String productId) =>
      dbHandler.fetchProductFields(productId);

  @override
  Future<void> fetchProductField(String id) => dbHandler.fetchProductField(id);

  @override
  Future<void> addProductField(ProductField field) =>
      dbHandler.addProductField(field);

  @override
  Future<void> deleteProductField(ProductField field) =>
      dbHandler.deleteProductField(field);
  // Currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() =>
      dbHandler.fetchAllCurencies();

  @override
  Future<void> addCurrencies(Currencies currencies) =>
      dbHandler.addCurrencies(currencies);

  @override
  Future<void> deleteCurrencies(Currencies currencies) =>
      dbHandler.deleteCurrencies(currencies);

  @override
  Future<List<Product>?> fetchAllProductsForAdmin() =>
      dbHandler.fetchAllProductsForAdmin();
}
