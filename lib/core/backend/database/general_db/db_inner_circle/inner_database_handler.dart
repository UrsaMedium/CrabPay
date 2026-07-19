import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';

abstract class InnerDatabaseHandler {
  //product
  Future<List<Product>?> fetchAllProducts();
  //fields
  Future<List<ProductField>?> fetchProductFields({required String productId});
  //currencies
  Future<List<Currencies>?> fetchAllCurencies();
  //featured products
  Future<List<String>> fetchAllFeaturedProducts();
  //user preferences
  Future<List<String>> fetchUserPreferences({required String userId});
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  });
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  });
}
