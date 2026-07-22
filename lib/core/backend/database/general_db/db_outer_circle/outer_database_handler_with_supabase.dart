import 'dart:convert'; // REQUIRED FOR THE JSON ENCODE FIX
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/supabase/supabase_graphql_client.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';
import 'package:flutter/foundation.dart';

class OuterDatabaseHandlerWithSupabase implements InnerDatabaseHandler {
  final GraphQLClient _client = SupabaseGraphQLClient.client;
  final retryer = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(milliseconds: 500),
  );

  Future<QueryResult> _mutateAndCheck(MutationOptions options) async {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'Running Mutate And Check',
      category: 'Database',
      data: {'options': options},
    );
    return await retryer.retry(() async {
      final result = await _client.mutate(options);

      if (result.hasException) {
        debugPrint('Supabase GraphQL Error: ${result.exception.toString()}');
        throw Exception(result.exception.toString());
      }
      return result;
    });
  }

  // ================= PRODUCTS =================

  @override
  Future<List<Product>?> fetchAllProducts() async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetch All Products',
        category: 'Database',
      );
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query {
            productCollection {
              edges {
                node { id, name, description, imageUrl, currencies }
              }
            }
          }
        '''),
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final nodes = result.data?['productCollection']['edges'] as List? ?? [];
      return nodes.map((edge) {
        final node = edge['node'];
        return Product(
          id: node['id'],
          name: node['name'],
          image: node['imageUrl'],
          description: node['description'],
          currencies: node['currencies'],
        );
      }).toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Fetch All Products',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      debugPrint('Failed to fetch: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch products');
      return null;
    }
  }

  // ================= FIELDS =================

  @override
  Future<List<ProductField>?> fetchProductFields({
    required String productId,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetch Product Fields',
        category: 'Database',
        data: {'productId': productId},
      );
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($productId: UUID!) {
            productFieldCollection(filter: { productId: { eq: $productId } }) {
              edges {
                node { id, productId, order, fieldName, isPriceImage, handler, priceImages, expectedData }
              }
            }
          }
        '''),
        variables: {'productId': productId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final nodes =
          result.data?['productFieldCollection']['edges'] as List? ?? [];
      return nodes.map((edge) {
        final node = edge['node'];

        Map<String, double>? priceImagesMap;
        if (node['priceImages'] != null) {
          final dynamic rawImages = node['priceImages'];
          // Safely handles both Stringified JSON and mapped JSON from the server
          final Map<String, dynamic> decodedImages = rawImages is String
              ? jsonDecode(rawImages)
              : Map<String, dynamic>.from(rawImages);
          priceImagesMap = decodedImages.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          );
        }

        List<String>? expectedDataList;
        if (node['expectedData'] != null &&
            (node['expectedData'] as List).isNotEmpty) {
          expectedDataList = List<String>.from(node['expectedData']);
        }

        return ProductField(
          id: node['id'],
          productId: node['productId'],
          order: node['order'],
          fieldName: node['fieldName'],
          isPriceImage: node['isPriceImage'],
          handler: node['handler'],
          priceImages: priceImagesMap,
          expectedData: expectedDataList,
        );
      }).toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Fetch Product Fields',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch fields');
      rethrow;
    }
  }

  // ================= CURRENCIES =================

  @override
  Future<List<Currencies>?> fetchAllCurencies() async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetch All Curencies',
        category: 'Database',
      );
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query {
            currenciesCollection {
              edges { node { id, name, mainCurrency, rub, usd } }
            }
          }
        '''),
      );
      final result = await retryer.retry(() => _client.query(options));
      final nodes =
          result.data?['currenciesCollection']['edges'] as List? ?? [];
      return nodes.map((e) {
        final n = e['node'];
        return Currencies(
          id: n['id'],
          name: n['name'],
          mainCurrency: n['mainCurrency'],
          rub: (n['rub'] as num).toDouble(),
          usd: (n['usd'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Fetch All Curencies',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch currencies');
      rethrow;
    }
  }

  // ================= PREFERENCES & FEATURED =================

  @override
  Future<List<String>> fetchAllFeaturedProducts() async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetch All Featured Products',
        category: 'Database',
      );
      final QueryOptions options = QueryOptions(
        document: gql(
          r''' query { featuredProductCollection { edges { node { featuredProductId } } } } ''',
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      );
      final result = await retryer.retry(() => _client.query(options));
      final nodes =
          result.data?['featuredProductCollection']['edges'] as List? ?? [];
      return nodes
          .map((e) => e['node']['featuredProductId'] as String)
          .toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Fetch All Featured Products',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch Featured Products');
      rethrow;
    }
  }

  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Add User Preference',
        category: 'Database',
        data: {'productId': productId, 'userId': userId},
      );
      final MutationOptions options = MutationOptions(
        document: gql(
          r''' mutation($uId: String!, $pId: UUID!) { insertIntouserPreferenceCollection(objects: [{ userId: $uId, favoriteProductId: $pId }]) { affectedCount } } ''',
        ),
        variables: {'uId': userId, 'pId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Add User Preference',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add User Preference');
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchUserPreferences({required String userId}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetch User Preferences',
        category: 'Database',
        data: {'userId': userId},
      );
      final QueryOptions options = QueryOptions(
        document: gql(
          r''' query($uId: String!) { userPreferenceCollection(filter: { userId: { eq: $uId } }) { edges { node { favoriteProductId } } } } ''',
        ),
        variables: {'uId': userId},
        fetchPolicy: FetchPolicy.networkOnly,
      );
      final result = await retryer.retry(() => _client.query(options));
      final nodes =
          result.data?['userPreferenceCollection']['edges'] as List? ?? [];
      return nodes
          .map((e) => e['node']['favoriteProductId'] as String)
          .toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Fetch User Preferences',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch User Preference');
      rethrow;
    }
  }

  @override
  Future<void> deleteUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Delete User Preference',
        category: 'Database',
        data: {'userId': userId, 'productId': productId},
      );
      final MutationOptions options = MutationOptions(
        document: gql(
          r''' mutation($uId: String!, $pId: UUID!) { deleteFromuserPreferenceCollection(filter: { userId: { eq: $uId }, favoriteProductId: { eq: $pId } }) { affectedCount } } ''',
        ),
        variables: {'uId': userId, 'pId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Delete User Preference',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to delete User Preference');
      rethrow;
    }
  }
}
