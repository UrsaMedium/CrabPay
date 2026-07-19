import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_inner_database_handler.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_outer_database_handler/admin_outer_database_handler_with_supabase.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';

class AdminBindingDatabaseHandler implements AdminInnerDatabaseHandler {
  final AdminInnerDatabaseHandler dbHandlerAdmin;
  AdminBindingDatabaseHandler({required this.dbHandlerAdmin});

  factory AdminBindingDatabaseHandler.dbService() =>
      AdminBindingDatabaseHandler(
        dbHandlerAdmin: (AdminOuterDatabaseHandlerWithSupabase()),
      );

  // Product
  @override
  Future<void> addProductAdmin({required Product product}) =>
      dbHandlerAdmin.addProductAdmin(product: product);

  @override
  Future<void> deleteProductAdmin({required Product product}) =>
      dbHandlerAdmin.deleteProductAdmin(product: product);

  // Fields

  @override
  Future<void> addProductFieldAdmin({required ProductField field}) =>
      dbHandlerAdmin.addProductFieldAdmin(field: field);

  @override
  Future<void> deleteProductFieldAdmin({required ProductField field}) =>
      dbHandlerAdmin.deleteProductFieldAdmin(field: field);
  // Currencies

  @override
  Future<void> addCurrenciesAdmin({required Currencies currencies}) =>
      dbHandlerAdmin.addCurrenciesAdmin(currencies: currencies);

  @override
  Future<void> deleteCurrenciesAdmin({required Currencies currencies}) =>
      dbHandlerAdmin.deleteCurrenciesAdmin(currencies: currencies);

  @override
  Future<void> updateProductAdmin({required Product product}) =>
      dbHandlerAdmin.updateProductAdmin(product: product);

  @override
  Future<void> addFeaturedProductAdmin({required String productId}) =>
      dbHandlerAdmin.addFeaturedProductAdmin(productId: productId);

  @override
  Future<void> deleteFeaturedProductAdmin({required String productId}) =>
      dbHandlerAdmin.deleteFeaturedProductAdmin(productId: productId);

  @override
  Future<void> updateProductFieldAdmin({required ProductField field}) =>
      dbHandlerAdmin.updateProductFieldAdmin(field: field);

  @override
  Future<void> updateProductFieldSwapImageFieldAdmin({
    required ProductField oldImageField,
    required ProductField newImageField,
  }) => dbHandlerAdmin.updateProductFieldSwapImageFieldAdmin(
    oldImageField: oldImageField,
    newImageField: newImageField,
  );
}
