import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:retry/retry.dart';

class OuterDatabseHandlerWithCustomPostgresqlServer
    implements InnerDatabaseHandler {
  final retryer = RetryOptions(
    maxAttempts: 3,
    delayFactor: const Duration(milliseconds: 300),
  );

  // Product
  // fetch all products
  @override
  Future<List<Product>?> fetchAllProducts() {
    // TODO: implement fetchAllProducts
    throw UnimplementedError();
  }

  // add Product
  @override
  Future<void> addProduct(Product product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  // delete Product
  @override
  Future<void> deleteProduct(Product product) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  //update product
  @override
  Future<void> updateProduct(
    String productId,
    String? imageName,
    String? productName,
    String? description,
  ) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  // Fields
  // fetch product fields
  @override
  @override
  Future<List<ProductField>?> fetchProductFields(String productId) {
    // TODO: implement fetchProductFields
    throw UnimplementedError();
  }

  // add Product Field
  @override
  Future<void> addProductField(ProductField field) {
    // TODO: implement addProductField
    throw UnimplementedError();
  }

  // delete a Field
  @override
  Future<void> deleteProductField(ProductField field) {
    // TODO: implement deleteProductField
    throw UnimplementedError();
  }

  //update product field
  @override
  Future<void> updateProductField(
    String fieldId,
    int? order,
    String? fieldName,
    bool? isPriceImage,
    Map<String, double>? priceImages,
    List<String>? expectedData,
  ) {
    // TODO: implement updateProductField
    throw UnimplementedError();
  }

  // Currencies
  // fetch all currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() {
    // TODO: implement fetchAllCurencies
    throw UnimplementedError();
  }

  // add currencies
  @override
  Future<void> addCurrencies(Currencies currencies) {
    // TODO: implement addCurrencies
    throw UnimplementedError();
  }

  // delete a curencies table
  @override
  Future<void> deleteCurrencies(Currencies currencies) {
    // TODO: implement deleteCurrencies
    throw UnimplementedError();
  }

  //featured products
  //fetch all featured products
  @override
  Future<List<String>> fetchAllFeaturedProducts() {
    // TODO: implement fetchAllFeaturedProducts
    throw UnimplementedError();
  }

  //add featured product
  @override
  Future<void> addFeaturedProduct(String productId) {
    // TODO: implement addFeaturedProduct
    throw UnimplementedError();
  }

  //delete featured product
  @override
  Future<void> deleteFeaturedProduct(String productId) {
    // TODO: implement deleteFeaturedProduct
    throw UnimplementedError();
  }

  //user preferences
  //add user preference
  @override
  Future<void> addUserPreference(String userId, String productId) {
    // TODO: implement addUserPreference
    throw UnimplementedError();
  }

  //fetch user preferences
  @override
  Future<List<String>> fetchUserPreferences(String userId) {
    // TODO: implement fetchUserPreferences
    throw UnimplementedError();
  }

  //delete user preference
  @override
  Future<void> deleteUserPreference(String userId, String productId) {
    // TODO: implement deleteUserPreference
    throw UnimplementedError();
  }
}
