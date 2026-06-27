import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';

abstract class InnerDatabaseHandler {
  //product
  Future<List<Product>?> fetchAllProducts();
  Future<List<Product>?> fetchAllProductsForAdmin();
  Future<void> addProduct(Product product);
  Future<void> deleteProduct(Product product);
  Future<void> updateProduct(
    String productId,
    String? imageName,
    String? productName,
    String? description,
  );
  //fields
  Future<List<ProductField>?> fetchProductFields(String productId);
  Future<void> fetchProductField(String id); // TODO
  Future<void> addProductField(ProductField field);
  Future<void> deleteProductField(ProductField field);
  //currencies
  Future<List<Currencies>?> fetchAllCurencies();
  Future<void> addCurrencies(Currencies currencies);
  Future<void> deleteCurrencies(Currencies currencies);
}
