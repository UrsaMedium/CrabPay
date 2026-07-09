import 'dart:convert'; // REQUIRED FOR THE JSON ENCODE FIX
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/supabase/supabase_graphql_client.dart';
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
    return await retryer.retry(() async {
      final result = await _client.mutate(options);

      if (result.hasException) {
        debugPrint('🚨 Supabase GraphQL Error: ${result.exception.toString()}');
        throw Exception(result.exception.toString());
      }
      return result;
    });
  }

  // ================= PRODUCTS =================

  @override
  Future<List<Product>?> fetchAllProducts() async {
    try {
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
      debugPrint('Failed to fetch: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch products');
      return null;
    }
  }

  @override
  Future<void> addProduct({required Product product}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID, $name: String!, $description: String!, $imageUrl: String!, $currencies: String!) {
            insertIntoproductCollection(objects: [{
              id: $id, name: $name, description: $description, imageUrl: $imageUrl, currencies: $currencies
            }]) { affectedCount }
          }
        '''),
        variables: {
          'id': product.id.isEmpty ? null : product.id,
          'name': product.name,
          'description': product.description,
          'imageUrl': product.image,
          'currencies': product.currencies,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add the product');
    }
  }

  @override
  Future<void> deleteProduct({required Product product}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) {
            deleteFromproductCollection(filter: { id: { eq: $id } }) { affectedCount }
          }
        '''),
        variables: {'id': product.id},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete the product');
    }
  }

  @override
  Future<void> updateProduct({required Product product}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!, $set: productUpdateInput!) {
            updateproductCollection(filter: { id: { eq: $id } }, set: $set) { affectedCount }
          }
        '''),
        variables: {
          'id': product.id,
          'set': {
            'imageUrl': product.image,
            'name': product.name,
            'description': product.description,
          }
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      rethrow;
    }
  }

  // ================= FIELDS =================

  @override
  Future<List<ProductField>?> fetchProductFields({
    required String productId,
  }) async {
    try {
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

      final nodes = result.data?['productFieldCollection']['edges'] as List? ?? [];
      return nodes.map((edge) {
        final node = edge['node'];

        Map<String, double>? priceImagesMap;
        if (node['priceImages'] != null) {
          final dynamic rawImages = node['priceImages'];
          // Safely handles both Stringified JSON and mapped JSON from the server
          final Map<String, dynamic> decodedImages = rawImages is String 
              ? jsonDecode(rawImages) 
              : Map<String, dynamic>.from(rawImages);
          priceImagesMap = decodedImages.map((k, v) => MapEntry(k, (v as num).toDouble()));
        }

        List<String>? expectedDataList;
        if (node['expectedData'] != null && (node['expectedData'] as List).isNotEmpty) {
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
      Fluttertoast.showToast(msg: 'Failed to fetch fields');
      rethrow;
    }
  }

  @override
  Future<void> addProductField({required ProductField field}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($productId: UUID!, $order: Int!, $fieldName: String!, $isPriceImage: Boolean!, $handler: String!, $priceImages: JSON, $expectedData: [String!]) {
            insertIntoproductFieldCollection(objects: [{
              productId: $productId, order: $order, fieldName: $fieldName, 
              isPriceImage: $isPriceImage, handler: $handler, 
              priceImages: $priceImages, expectedData: $expectedData
            }]) { affectedCount }
          }
        '''),
        variables: {
          'productId': field.productId,
          'order': field.order,
          'fieldName': field.fieldName,
          'isPriceImage': field.isPriceImage,
          'handler': field.handler,
          // MAGIC FIX: Stringify the map so pg_graphql handles it correctly
          'priceImages': field.priceImages != null ? jsonEncode(field.priceImages) : null,
          'expectedData': field.expectedData,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add the field');
      rethrow;
    }
  }

  @override
  Future<void> deleteProductField({required ProductField field}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) {
            deleteFromproductFieldCollection(filter: { id: { eq: $id } }) { affectedCount }
          }
        '''),
        variables: {'id': field.id},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete the field');
      rethrow;
    }
  }

  @override
  Future<void> updateProductField({required ProductField field}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!, $set: productFieldUpdateInput!) {
            updateproductFieldCollection(filter: { id: { eq: $id } }, set: $set) { affectedCount }
          }
        '''),
        variables: {
          'id': field.id,
          'set': {
            'order': field.order,
            'fieldName': field.fieldName,
            'isPriceImage': field.isPriceImage,
            // MAGIC FIX: Stringify the map so pg_graphql handles it correctly
            'priceImages': field.priceImages != null ? jsonEncode(field.priceImages) : null,
            'expectedData': field.expectedData,
          }
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      rethrow;
    }
  }

  // ================= CURRENCIES =================

  @override
  Future<List<Currencies>?> fetchAllCurencies() async {
    try {
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
      final nodes = result.data?['currenciesCollection']['edges'] as List? ?? [];
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
      Fluttertoast.showToast(msg: 'Failed to fetch currencies');
      rethrow;
    }
  }

  @override
  Future<void> addCurrencies({required Currencies currencies}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($name: String!, $mainCurrency: String!, $rub: Float!, $usd: Float!) {
            insertIntocurrenciesCollection(objects: [{
              name: $name, mainCurrency: $mainCurrency, rub: $rub, usd: $usd
            }]) { affectedCount }
          }
        '''),
        variables: {
          'name': currencies.name,
          'mainCurrency': currencies.mainCurrency,
          'rub': currencies.rub,
          'usd': currencies.usd,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add the currencies');
      rethrow;
    }
  }

  @override
  Future<void> deleteCurrencies({required Currencies currencies}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) { deleteFromcurrenciesCollection(filter: { id: { eq: $id } }) { affectedCount } }
        '''),
        variables: {'id': currencies.id},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete the currencies');
      rethrow;
    }
  }

  // ================= PREFERENCES & FEATURED =================

  @override
  Future<List<String>> fetchAllFeaturedProducts() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r''' query { featuredProductCollection { edges { node { featuredProductId } } } } '''),
        fetchPolicy: FetchPolicy.networkOnly,
      );
      final result = await retryer.retry(() => _client.query(options));
      final nodes = result.data?['featuredProductCollection']['edges'] as List? ?? [];
      return nodes.map((e) => e['node']['featuredProductId'] as String).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch Featured Products');
      rethrow;
    }
  }

  @override
  Future<void> addFeaturedProduct({required String productId}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r''' mutation($fId: UUID!) { insertIntofeaturedProductCollection(objects: [{ featuredProductId: $fId }]) { affectedCount } } '''),
        variables: {'fId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> deleteFeaturedProduct({required String productId}) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r''' mutation($fId: UUID!) { deleteFromfeaturedProductCollection(filter: { featuredProductId: { eq: $fId } }) { affectedCount } } '''),
        variables: {'fId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> addUserPreference({
    required String userId,
    required String productId,
  }) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r''' mutation($uId: String!, $pId: UUID!) { insertIntouserPreferenceCollection(objects: [{ userId: $uId, favoriteProductId: $pId }]) { affectedCount } } '''),
        variables: {'uId': userId, 'pId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add User Preference');
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchUserPreferences({required String userId}) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r''' query($uId: String!) { userPreferenceCollection(filter: { userId: { eq: $uId } }) { edges { node { favoriteProductId } } } } '''),
        variables: {'uId': userId},
        fetchPolicy: FetchPolicy.networkOnly,
      );
      final result = await retryer.retry(() => _client.query(options));
      final nodes = result.data?['userPreferenceCollection']['edges'] as List? ?? [];
      return nodes.map((e) => e['node']['favoriteProductId'] as String).toList();
    } catch (e) {
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
      final MutationOptions options = MutationOptions(
        document: gql(r''' mutation($uId: String!, $pId: UUID!) { deleteFromuserPreferenceCollection(filter: { userId: { eq: $uId }, favoriteProductId: { eq: $pId } }) { affectedCount } } '''),
        variables: {'uId': userId, 'pId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
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