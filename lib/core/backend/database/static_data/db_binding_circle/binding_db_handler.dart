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

  @override
  Future<void> updateProduct(
    String productId,
    String? imageName,
    String? productName,
    String? description,
  ) => dbHandler.updateProduct(productId, imageName, productName, description);

  @override
  Future<List<String>> fetchAllFeaturedProducts() =>
      dbHandler.fetchAllFeaturedProducts();

  @override
  Future<void> addFeaturedProduct(String productId) =>
      dbHandler.addFeaturedProduct(productId);

  @override
  Future<void> addUserPreference(String userId, String productId) =>
      dbHandler.addUserPreference(userId, productId);

  @override
  Future<List<String>> fetchUserPreferences(String userId) =>
      dbHandler.fetchUserPreferences(userId);

  @override
  Future<void> deleteFeaturedProduct(String productId) =>
      dbHandler.deleteFeaturedProduct(productId);

  @override
  Future<void> deleteUserPreference(String userId, String productId) =>
      dbHandler.deleteUserPreference(userId, productId);

  @override
  Future<void> updateProductField(
    String fieldId,
    int? order,
    String? fieldName,
    bool? isPriceImage,
    Map<String, double>? priceImages,
    List<String>? expectedData,
  ) => dbHandler.updateProductField(
    fieldId,
    order,
    fieldName,
    isPriceImage,
    priceImages,
    expectedData,
  );
}
