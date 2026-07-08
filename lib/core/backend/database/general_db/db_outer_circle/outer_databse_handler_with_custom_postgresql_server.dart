import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_currencies.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_featured_product.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_product.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_product_field.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_add_user_preference.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_currencies.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_featured_product.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_product.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_product_field.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_delete_user_preference.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_update_product.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/mutation_update_product_field.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_all_currencies.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_all_products.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_all_user_preferences.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/query_fetch_featured_products.dart';
import 'package:crabpay/core/backend/postgresql_server/lib/quiery_fetch_product_fields.dart';
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';

class OuterDatabseHandlerWithCustomPostgresqlServer
    implements InnerDatabaseHandler {
  final retryer = RetryOptions(
    maxAttempts: 3,
    delayFactor: const Duration(milliseconds: 300),
  );

  // Product
  // fetch all products
  @override
  Future<List<Product>?> fetchAllProducts() async {
    try {
      return await retryer.retry(() => QueryFetchAllProducts().execute());
    } catch (e) {
      rethrow;
    }
  }

  // add Product
  @override
  Future<void> addProduct({required Product product}) async {
    try {
      if (Uuid.isValidUUID(fromString: product.id)) {
        await retryer.retry(
          () => MutationAddProduct(
            id: product.id,
            name: product.name,
            imageUrl: product.image,
            currencies: product.currencies,
            description: product.description,
          ).execute(),
        );
      } else {
        await retryer.retry(
          () => MutationAddProduct(
            name: product.name,
            imageUrl: product.image,
            currencies: product.currencies,
            description: product.description,
          ).execute(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // delete Product
  @override
  Future<void> deleteProduct({required Product product}) async {
    try {
      await retryer.retry(
        () => MutationDeleteProduct(id: product.id).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //update product
  @override
  Future<void> updateProduct({
    required String productId,
    String? imageName,
    String? productName,
    String? description,
  }) async {
    try {
      await retryer.retry(
        () => MutationUpdateProduct(
          id: productId,
          imageUrl: imageName,
          name: productName,
          description: description,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Fields
  // fetch product fields
  @override
  Future<List<ProductField>?> fetchProductFields({
    required String productId,
  }) async {
    try {
      return await retryer.retry(
        () => QuieryFetchProductFields(productId: productId).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // add Product Field
  @override
  Future<void> addProductField({required ProductField field}) async {
    try {
      await retryer.retry(
        () => MutationAddProductField(
          productId: field.productId,
          order: field.order,
          priceImages: field.priceImages,
          expectedData: field.expectedData,
          handler: field.handler,
          fieldName: field.fieldName,
          isPriceImage: field.isPriceImage,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // delete a Field
  @override
  Future<void> deleteProductField({required ProductField field}) async {
    try {
      await retryer.retry(
        () => MutationDeleteProductField(id: field.id).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //update product field
  @override
  Future<void> updateProductField({
    required String fieldId,
    int? order,
    String? fieldName,
    bool? isPriceImage,
    Map<String, double>? priceImages,
    List<String>? expectedData,
  }) async {
    try {
      await retryer.retry(
        () => MutationUpdateProductField(
          id: fieldId,
          order: order,
          fieldName: fieldName,
          isPriceImage: isPriceImage,
          priceImages: priceImages,
          expectedData: expectedData,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Currencies
  // fetch all currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() async {
    try {
      return await retryer.retry(() => QueryGetAllCurrencies().execute());
    } catch (e) {
      rethrow;
    }
  }

  // add currencies
  @override
  Future<void> addCurrencies({required Currencies currencies}) async {
    try {
      await retryer.retry(
        () => MutationAddCurrencies(
          name: currencies.name,
          mainCurrency: currencies.mainCurrency,
          rub: currencies.rub,
          usd: currencies.usd,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // delete a curencies table
  @override
  Future<void> deleteCurrencies({required Currencies currencies}) async {
    try {
      await retryer.retry(
        () => MutationDeleteCurrencies(id: currencies.id).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //featured products
  //fetch all featured products
  @override
  Future<List<String>> fetchAllFeaturedProducts() async {
    try {
      return await retryer.retry(() => QueryGetFeaturedProducts().execute());
    } catch (e) {
      rethrow;
    }
  }

  //add featured product
  @override
  Future<void> addFeaturedProduct({required String productId}) async {
    try {
      await retryer.retry(
        () =>
            MutationAddFeaturedProduct(featuredProductId: productId).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //delete featured product
  @override
  Future<void> deleteFeaturedProduct({required String productId}) async {
    try {
      await retryer.retry(
        () => MutationDeleteFeaturedProduct(
          featuredProductId: productId,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //user preferences
  //add user preference
  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      await retryer.retry(
        () => MutationAddUserPreference(
          userId: userId,
          favoriteProductId: productId,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //fetch user preferences
  @override
  Future<List<String>> fetchUserPreferences({required String userId}) async {
    try {
      return await retryer.retry(
        () => QueryGetUserPreferences(userId: userId).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }

  //delete user preference
  @override
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      await retryer.retry(
        () => MutationDeleteUserPreference(
          userId: userId,
          favoriteProductId: productId,
        ).execute(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
