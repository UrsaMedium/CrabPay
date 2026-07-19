import 'dart:convert'; // REQUIRED FOR THE JSON ENCODE FIX
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/supabase/supabase_graphql_client.dart';
import 'package:crabpay/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';
import 'package:flutter/foundation.dart';

class AdminOuterDatabaseHandlerWithSupabase
    implements AdminInnerDatabaseHandler {
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
  Future<void> addProductAdmin({required Product product}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Add Product',
        category: 'Database',
        data: {'product': product},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Add Product',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add the product');
    }
  }

  @override
  Future<void> deleteProductAdmin({required Product product}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Delete Product',
        category: 'Database',
        data: {'product': product},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Delete Product',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to delete the product');
    }
  }

  @override
  Future<void> updateProductAdmin({required Product product}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Update Product',
        category: 'Database',
        data: {'product': product},
      );
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
          },
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Update Product',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  // ================= FIELDS =================

  @override
  Future<void> addProductFieldAdmin({required ProductField field}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Add Product Field',
        category: 'Database',
        data: {'field': field},
      );
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
          'priceImages': field.priceImages != null
              ? jsonEncode(field.priceImages)
              : null,
          'expectedData': field.expectedData,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Add Product Field',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add the field');
      rethrow;
    }
  }

  @override
  Future<void> deleteProductFieldAdmin({required ProductField field}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Delete Product Field',
        category: 'Database',
        data: {'field': field},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Delete Product Field',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to delete the field');
      rethrow;
    }
  }

  @override
  Future<void> updateProductFieldAdmin({required ProductField field}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Update Product Field',
        category: 'Database',
        data: {'field': field},
      );
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
            'priceImages': field.priceImages != null
                ? jsonEncode(field.priceImages)
                : null,
            'expectedData': field.expectedData,
          },
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Update Product Field',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  // ================= CURRENCIES =================

  @override
  Future<void> addCurrenciesAdmin({required Currencies currencies}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Add urrencies',
        category: 'Database',
        data: {'currencies': currencies},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Add Currencies',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add the currencies');
      rethrow;
    }
  }

  @override
  Future<void> deleteCurrenciesAdmin({required Currencies currencies}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Delete Currencies',
        category: 'Database',
        data: {'currencies': currencies},
      );
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) { deleteFromcurrenciesCollection(filter: { id: { eq: $id } }) { affectedCount } }
        '''),
        variables: {'id': currencies.id},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Delete Currencies',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to delete the currencies');
      rethrow;
    }
  }

  // ================= PREFERENCES & FEATURED =================

  @override
  Future<void> addFeaturedProductAdmin({required String productId}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Add Featured Product',
        category: 'Database',
        data: {'productId': productId},
      );
      final MutationOptions options = MutationOptions(
        document: gql(
          r''' mutation($fId: UUID!) { insertIntofeaturedProductCollection(objects: [{ featuredProductId: $fId }]) { affectedCount } } ''',
        ),
        variables: {'fId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Add Featured Product',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> deleteFeaturedProductAdmin({required String productId}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Delete Featured Product',
        category: 'Database',
        data: {'productId': productId},
      );
      final MutationOptions options = MutationOptions(
        document: gql(
          r''' mutation($fId: UUID!) { deleteFromfeaturedProductCollection(filter: { featuredProductId: { eq: $fId } }) { affectedCount } } ''',
        ),
        variables: {'fId': productId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed To Delete Featured Product',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to delete Featured Product');
      rethrow;
    }
  }

  @override
  Future<void> updateProductFieldSwapImageFieldAdmin({
    required ProductField oldImageField,
    required ProductField newImageField,
  }) {
    // TODO: implement updateProductFieldSwapImageField
    throw UnimplementedError();
  }
}
