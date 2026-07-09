import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';

class OuterDatabaseHandlerWithFirebaseSql implements InnerDatabaseHandler {
  final retryer = RetryOptions(
    maxAttempts: 3,
    delayFactor: const Duration(milliseconds: 500),
  );
  // Product
  // fetch all products
  @override
  Future<List<Product>?> fetchAllProducts() async {
    try {
      final productFetrcher = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getAllProductsQuery()
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      List<Product> fetchedProducts = [];
      for (var product in productFetrcher.data.products) {
        fetchedProducts.add(
          Product(
            id: product.id,
            name: product.name,
            image: product.imageUrl,
            description: product.description,
            currencies: product.currencies,
          ),
        );
      }
      Fluttertoast.showToast(msg: 'Suck sus');
      return fetchedProducts;
    } catch (e) {
      print('Failed to fetch: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch: $e');
      return null;
    }
  }

  // add Product
  @override
  Future<void> addProduct({required Product product}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addProduct(
              description: product.description,
              imageUrl: product.image,
              name: product.name,
              currencies: product.currencies,
            )
            .id(product.id == '' ? null : product.id)
            .execute(),
      );
    } catch (e) {
      print('Failed to add the product: $e');
      Fluttertoast.showToast(msg: 'Failed to add the product: $e');
    }
  }

  // delete Product
  @override
  Future<void> deleteProduct({required Product product}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteProduct(id: product.id)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete the product: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the product: $e');
    }
  }

  @override
  Future<void> updateProduct({
    required Product product
  }) async {
    // try {
    //   final mutation = CrabpayConnectorConnector.instance.updateProduct(
    //     id: productId,
    //   );

    //   if (imageName != null) mutation.imageUrl(imageName);
    //   if (productName != null) mutation.name(productName);
    //   if (description != null) mutation.description(description);

    //   await retryer.retry(() => mutation.execute());
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Fields
  // fetch product fields
  @override
  Future<List<ProductField>?> fetchProductFields({
    required String productId,
  }) async {
    try {
      final fetchedFields = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getProductFieldsQuery(productId: productId)
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      List<ProductField> processedFetchedFields = [];
      for (var each in fetchedFields.data.productFields) {
        final jsonPriceImages = each.priceImages?.toJson();
        final priceImages = jsonPriceImages == null
            ? null
            : Map<String, dynamic>.from(
                jsonPriceImages,
              ).map((key, value) => MapEntry(key, (value as num).toDouble()));
        final expectedData = each.expectedData == []
            ? null
            : each.expectedData?.toList();
        processedFetchedFields.add(
          ProductField(
            id: each.id,
            productId: productId,
            order: each.order,
            fieldName: each.fieldName,
            isPriceImage: each.isPriceImage,
            handler: each.handler,
            priceImages: priceImages,
            expectedData: expectedData,
          ),
        );
      }
      return processedFetchedFields;
    } catch (e) {
      print('Failed to fetch fields: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch fields: $e');
      rethrow;
    }
  }

  // add Product Field
  @override
  Future<void> addProductField({required ProductField field}) async {
    try {
      AnyValue? priceImages;
      if (field.priceImages != null) {
        priceImages = AnyValue(field.priceImages!.cast<String, double>());
      }
      List<String>? expectedData;
      if (field.expectedData != null) {
        expectedData = field.expectedData;
      }
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addProductField(
              productId: field.productId,
              order: field.order,
              handler: field.handler,
              fieldName: field.fieldName,
              isPriceImage: field.isPriceImage,
            )
            .priceImages(priceImages)
            .expectedData(expectedData)
            .execute(),
      );
    } catch (e) {
      print('Failed to add the field: $e');
      Fluttertoast.showToast(msg: 'Failed to add the field: $e');
      rethrow;
    }
  }

  // delete a Field
  @override
  Future<void> deleteProductField({required ProductField field}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteProductField(id: field.id)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete the field: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the field: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProductField({
    required ProductField field
  }) async {
    // try {
    //   final mutation = CrabpayConnectorConnector.instance.updateProductField(
    //     id: fieldId,
    //   );
    //   if (isPriceImage == null) {
    //     AnyValue? priceImagesToPush;
    //     if (priceImages != null) {
    //       priceImagesToPush = AnyValue(priceImages.cast<String, double>());
    //     }

    //     if (order != null) mutation.order(order);
    //     if (fieldName != null) mutation.fieldName(fieldName);
    //     if (priceImages != null) mutation.priceImages(priceImagesToPush);
    //     if (expectedData != null) mutation.expectedData(expectedData);

    //     await retryer.retry(() => mutation.execute());
    //   } else if (isPriceImage) {
    //     if (priceImages != null) {
    //       AnyValue? priceImagesToPush;
    //       priceImagesToPush = AnyValue(priceImages.cast<String, double>());
    //       retryer.retry(
    //         () => mutation
    //             .isPriceImage(true)
    //             .priceImages(priceImagesToPush)
    //             .execute(),
    //       );
    //     }
    //   } else {
    //     retryer.retry(
    //       () => mutation.isPriceImage(false).priceImages(null).execute(),
    //     );
    //   }
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Currencies
  // fetch all currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() async {
    List<Currencies> processedFetchedAllCurrencies = [];
    try {
      final fetchedAllCurrencies = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getAllCurrenciesQuery()
            .execute(),
      );
      for (var currencies in fetchedAllCurrencies.data.currenciess) {
        processedFetchedAllCurrencies.add(
          Currencies(
            id: currencies.id,
            mainCurrency: currencies.mainCurrency,
            name: currencies.name,
            rub: currencies.rub,
            usd: currencies.usd,
          ),
        );
      }
      return processedFetchedAllCurrencies;
    } catch (e) {
      print('Failed to fetch all currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch all currencies: $e');
      rethrow;
    }
  }

  // add currencies
  @override
  Future<void> addCurrencies({required Currencies currencies}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addCurrencies(
              name: currencies.name,
              mainCurrency: currencies.mainCurrency,
              rub: currencies.rub,
              usd: currencies.usd,
            )
            .execute(),
      );
    } catch (e) {
      print('Failed to add the currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to add the currencies: $e');
      rethrow;
    }
  }

  // delete a curencies table
  @override
  Future<void> deleteCurrencies({required Currencies currencies}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteCurrencies(id: currencies.id)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete the currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the currencies: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchAllFeaturedProducts() async {
    List<String> result = [];
    try {
      final fetchedFeaturedProducts = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getFeaturedProducts()
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      if (fetchedFeaturedProducts.data.featuredProducts.isNotEmpty) {
        for (var featuredProduct
            in fetchedFeaturedProducts.data.featuredProducts) {
          result.add(featuredProduct.featuredProductId!);
        }
      }
      return result;
    } catch (e) {
      print('Failed to fetch Featured Products: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch Featured Products');
      rethrow;
    }
  }

  @override
  Future<void> addFeaturedProduct({required String productId}) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addFeaturedProduct(featuredProductId: productId)
            .execute(),
      );
    } catch (e) {
      print('Failed to add Featured Product: $e');
      Fluttertoast.showToast(msg: 'Failed to add Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .addUserPreference(userId: userId, favoriteProductId: productId)
            .execute(),
      );
    } catch (e) {
      print('Failed to add User Preference: $e');
      Fluttertoast.showToast(msg: 'Failed to add User Preference');
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchUserPreferences({required String userId}) async {
    List<String> result = [];
    try {
      final fetchedUserPreferences = await retryer.retry(
        () => CrabpayConnectorConnector.instance
            .getUserPreferences(userId: userId)
            .ref()
            .execute(fetchPolicy: QueryFetchPolicy.serverOnly),
      );
      for (var userPreference in fetchedUserPreferences.data.userPreferences) {
        result.add(userPreference.favoriteProductId!);
      }
      return result;
    } catch (e) {
      print('Failed to fetch User Preference: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch User Preference');
      rethrow;
    }
  }

  @override
  Future<void> deleteFeaturedProduct({required String productId}) async {
    print(productId);
    try {
      retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteFeaturedProduct(featuredProductId: productId)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete Featured Product: $e');
      Fluttertoast.showToast(msg: 'Failed to delete Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      retryer.retry(
        () => CrabpayConnectorConnector.instance
            .deleteUserPreference(userId: userId, favoriteProductId: productId)
            .execute(),
      );
    } catch (e) {
      print('Failed to delete User Preference: $e');
      Fluttertoast.showToast(msg: 'Failed to delete User Preference');
      rethrow;
    }
  }
  
  @override
  Future<void> updateProductFieldSwapImageField({required ProductField oldImageField, required ProductField newImageField}) {
    // TODO: implement updateProductFieldSwapImageField
    throw UnimplementedError();
  }
}
