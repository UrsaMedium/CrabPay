import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';

abstract class AdminInnerDatabaseHandler {
  //product
  Future<void> addProductAdmin({required Product product});
  Future<void> deleteProductAdmin({required Product product});
  Future<void> updateProductAdmin({required Product product});
  //fields
  Future<void> addProductFieldAdmin({required ProductField field});
  Future<void> deleteProductFieldAdmin({required ProductField field});
  Future<void> updateProductFieldAdmin({required ProductField field});
  Future<void> updateProductFieldSwapImageFieldAdmin({
    required ProductField oldImageField,
    required ProductField newImageField,
  });
  //currencies
  Future<void> addCurrenciesAdmin({required Currencies currencies});
  Future<void> deleteCurrenciesAdmin({required Currencies currencies});
  //featured products
  Future<void> addFeaturedProductAdmin({required String productId});
  Future<void> deleteFeaturedProductAdmin({required String productId});

}
