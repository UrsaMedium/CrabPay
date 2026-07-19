import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_outer_circle/outer_database_handler_with_supabase.dart';

class BindingDatabaseHandler implements InnerDatabaseHandler {
  final InnerDatabaseHandler dbHandler;
  BindingDatabaseHandler({required this.dbHandler});

  factory BindingDatabaseHandler.dbService() =>
      BindingDatabaseHandler(dbHandler: (OuterDatabaseHandlerWithSupabase()));

  // Product
  @override
  // Fields
  @override
  Future<List<ProductField>?> fetchProductFields({required String productId}) =>
      dbHandler.fetchProductFields(productId: productId);

  // Currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() =>
      dbHandler.fetchAllCurencies();

  @override
  Future<List<Product>?> fetchAllProducts() => dbHandler.fetchAllProducts();

  @override
  Future<List<String>> fetchAllFeaturedProducts() =>
      dbHandler.fetchAllFeaturedProducts();

  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) => dbHandler.addUserPreference(userId: userId, productId: productId);

  @override
  Future<List<String>> fetchUserPreferences({required String userId}) =>
      dbHandler.fetchUserPreferences(userId: userId);

  @override
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  }) => dbHandler.deleteUserPreference(userId: userId, productId: productId);
}
