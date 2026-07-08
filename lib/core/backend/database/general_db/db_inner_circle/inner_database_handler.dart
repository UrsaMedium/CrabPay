import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';

abstract class InnerDatabaseHandler {
  //product
  Future<List<Product>?> fetchAllProducts();
  Future<void> addProduct({required Product product});
  Future<void> deleteProduct({required Product product});
  Future<void> updateProduct({
    required String productId,
    String? imageName,
    String? productName,
    String? description,
  });
  //fields
  Future<List<ProductField>?> fetchProductFields({required String productId});
  Future<void> addProductField({required ProductField field});
  Future<void> deleteProductField({required ProductField field});
  Future<void> updateProductField({
    required String fieldId,
    int? order,
    String? fieldName,
    bool? isPriceImage,
    Map<String, double>? priceImages,
    List<String>? expectedData,
  });
  //currencies
  Future<List<Currencies>?> fetchAllCurencies();
  Future<void> addCurrencies({required Currencies currencies});
  Future<void> deleteCurrencies({required Currencies currencies});
  //featured products
  Future<List<String>> fetchAllFeaturedProducts();
  Future<void> addFeaturedProduct({required String productId});
  Future<void> deleteFeaturedProduct({required String productId});
  //user preferences
  Future<List<String>> fetchUserPreferences({required String userId});
  Future<void> addUserPreference({required String userId, required String productId});
  Future<void> deleteUserPreference({required String userId, required String productId});
}
