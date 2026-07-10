import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_outer_circle/outer_database_handler_with_supabase.dart';

class BindingDatabaseHandler implements InnerDatabaseHandler {
  final InnerDatabaseHandler dbHandler;
  BindingDatabaseHandler({required this.dbHandler});

  factory BindingDatabaseHandler.firebaseDb() => BindingDatabaseHandler(
    dbHandler: (OuterDatabaseHandlerWithSupabase()),
  );

  // Product
  @override
  Future<void> addProduct({required Product product}) =>
      dbHandler.addProduct(product: product);

  @override
  Future<void> deleteProduct({required Product product}) =>
      dbHandler.deleteProduct(product: product);

  // Fields
  @override
  Future<List<ProductField>?> fetchProductFields({required String productId}) =>
      dbHandler.fetchProductFields(productId: productId);

  @override
  Future<void> addProductField({required ProductField field}) =>
      dbHandler.addProductField(field: field);

  @override
  Future<void> deleteProductField({required ProductField field}) =>
      dbHandler.deleteProductField(field: field);
  // Currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() =>
      dbHandler.fetchAllCurencies();

  @override
  Future<void> addCurrencies({required Currencies currencies}) =>
      dbHandler.addCurrencies(currencies: currencies);

  @override
  Future<void> deleteCurrencies({required Currencies currencies}) =>
      dbHandler.deleteCurrencies(currencies: currencies);

  @override
  Future<List<Product>?> fetchAllProducts() => dbHandler.fetchAllProducts();

  @override
  Future<void> updateProduct({required Product product}) =>
      dbHandler.updateProduct(product: product);

  @override
  Future<List<String>> fetchAllFeaturedProducts() =>
      dbHandler.fetchAllFeaturedProducts();

  @override
  Future<void> addFeaturedProduct({required String productId}) =>
      dbHandler.addFeaturedProduct(productId: productId);

  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) => dbHandler.addUserPreference(userId: userId, productId: productId);

  @override
  Future<List<String>> fetchUserPreferences({required String userId}) =>
      dbHandler.fetchUserPreferences(userId: userId);

  @override
  Future<void> deleteFeaturedProduct({required String productId}) =>
      dbHandler.deleteFeaturedProduct(productId: productId);

  @override
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  }) => dbHandler.deleteUserPreference(userId: userId, productId: productId);

  @override
  Future<void> updateProductField({required ProductField field}) =>
      dbHandler.updateProductField(field: field);

  @override
  Future<void> updateProductFieldSwapImageField({
    required ProductField oldImageField,
    required ProductField newImageField,
  }) => dbHandler.updateProductFieldSwapImageField(
    oldImageField: oldImageField,
    newImageField: newImageField,
  );
}
