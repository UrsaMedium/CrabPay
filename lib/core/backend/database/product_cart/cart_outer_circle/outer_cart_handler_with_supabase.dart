import 'dart:convert'; // REQUIRED FOR THE JSON ENCODE FIX
import 'dart:async';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend/supabase/supabase_graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';

class OuterCartHandlerWithSupabase implements InnerCartHandler {
  final GraphQLClient _client = SupabaseGraphQLClient.client;
  final retryer = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(milliseconds: 500),
  );

  Future<QueryResult> _mutateAndCheck(MutationOptions options) async {
    return await retryer.retry(() async {
      final result = await _client.mutate(options);

      if (result.hasException) {
        debugPrint(
          '🚨 Supabase Cart GraphQL Error: ${result.exception.toString()}',
        );
        throw Exception(result.exception.toString());
      }
      return result;
    });
  }

  List<CartItem> _dataCasting(List<dynamic> edges) {
    return edges.map((edge) {
      final item = edge['node'];
      final dynamic rawPurchaseData = item['purchaseData'] ?? {};

      // Safely handles both Stringified JSON and mapped JSON from the server
      final Map<String, dynamic> decodedPurchaseData = rawPurchaseData is String
          ? jsonDecode(rawPurchaseData)
          : Map<String, dynamic>.from(rawPurchaseData);

      final Map<String, String> finalPurchaseData = decodedPurchaseData.map(
        (k, v) => MapEntry(k, v.toString()),
      );

      return CartItem(
        id: item['id'],
        userId: item['userId'],
        userName: item['userName'],
        productId: item['productId'],
        productName: item['productName'],
        purchaseData: finalPurchaseData,
        currency: item['currency'],
        checkoutPrice: (item['checkoutPrice'] as num).toDouble(),
        status: item['status'],
        comment: item['comment'],
      );
    }).toList();
  }

  @override
  Future<List<CartItem>> fetchCartItems(String userId) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($userId: String!) {
            cartItemCollection(filter: { userId: { eq: $userId } }) {
              edges {
                node { id, userId, userName, productId, productName, purchaseData, currency, checkoutPrice, status, comment }
              }
            }
          }
        '''),
        variables: {'userId': userId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final nodes = result.data?['cartItemCollection']['edges'] as List? ?? [];
      return _dataCasting(nodes);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch cart items');
      rethrow;
    }
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) { deleteFromcartItemCollection(filter: { id: { eq: $id } }) { affectedCount } }
        '''),
        variables: {'id': cartItemId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete the cart item');
      rethrow;
    }
  }

  @override
  Future<void> addCartItem(CartItem cartItem) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($userId: String!, $userName: String!, $productId: UUID!, $productName: String!, $purchaseData: JSON!, $currency: String!, $checkoutPrice: Float!, $status: String!, $comment: String) {
            insertIntocartItemCollection(objects: [{
              userId: $userId, userName: $userName, productId: $productId, productName: $productName,
              purchaseData: $purchaseData, currency: $currency, checkoutPrice: $checkoutPrice, status: $status, comment: $comment
            }]) { affectedCount }
          }
        '''),
        variables: {
          'userId': cartItem.userId,
          'userName': cartItem.userName,
          'productId': cartItem.productId,
          'productName': cartItem.productName,
          // MAGIC FIX: Stringify the map so pg_graphql handles it correctly
          'purchaseData': jsonEncode(cartItem.purchaseData),
          'currency': cartItem.currency,
          'checkoutPrice': cartItem.checkoutPrice,
          'status': cartItem.status,
          'comment': cartItem.comment,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add the cart item');
      rethrow;
    }
  }

  @override
  Stream<List<CartItem>> cartItemsStream(String userId) {
    final SubscriptionOptions options = SubscriptionOptions(
      document: gql(r'''
        subscription($userId: String!) {
          cartItemCollection(filter: { userId: { eq: $userId } }) {
            edges {
              node { id, userId, userName, productId, productName, purchaseData, currency, checkoutPrice, status, comment }
            }
          }
        }
      '''),
      variables: {'userId': userId},
    );

    return _client.subscribe(options).map((result) {
      final nodes = result.data?['cartItemCollection']['edges'] as List? ?? [];
      return _dataCasting(nodes);
    });
  }

  @override
  Future<void> updateCartItem(
    List<CartItem> cartItems,
    AppAuthUser? user,
  ) async {
    try {
      if (user == null) {
        for (var item in cartItems) {
          final MutationOptions options = MutationOptions(
            document: gql(r'''
              mutation($id: UUID!, $status: String!, $time: Datetime!) {
                updatecartItemCollection(
                  filter: { id: { eq: $id } }, 
                  set: { status: $status, statusChangedAt: $time }
                ) { affectedCount }
              }
            '''),
            variables: {
              'id': item.id,
              'status': 'beingCheckedOut',
              'time': DateTime.now().toUtc().toIso8601String(),
            },
          );
          await _mutateAndCheck(options);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getProductCartItemAmount(String userId, String productId) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($uId: String!, $pId: UUID!) {
            ofUserOfProductCartItemCounterCollection(filter: { userId: { eq: $uId }, productId: { eq: $pId } }) {
              edges { node { productCartItemCount } }
            }
          }
        '''),
        variables: {'uId': userId, 'pId': productId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));

      // 🚨 STOP SILENT FAILURES ON QUERIES
      if (result.hasException) {
        debugPrint(
          '🚨 GraphQL Query Error (Product Cart Count): ${result.exception.toString()}',
        );
        throw Exception(result.exception.toString());
      }

      final nodes =
          result.data?['ofUserOfProductCartItemCounterCollection']['edges']
              as List? ??
          [];

      if (nodes.isEmpty) return 0;

      return nodes.first['node']['productCartItemCount'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUserCartItemAmount(String userId) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($uId: String!) {
            ofUserCartItemCounterCollection(filter: { userId: { eq: $uId } }) {
              edges { node { userCartItemCount } }
            }
          }
        '''),
        variables: {'uId': userId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));

      // 🚨 STOP SILENT FAILURES ON QUERIES
      if (result.hasException) {
        debugPrint(
          '🚨 GraphQL Query Error (User Cart Count): ${result.exception.toString()}',
        );
        throw Exception(result.exception.toString());
      }

      final nodes =
          result.data?['ofUserCartItemCounterCollection']['edges'] as List? ??
          [];

      if (nodes.isEmpty) return 0;

      return nodes.first['node']['userCartItemCount'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteLastAddedProductCartItem(
    String userId,
    String productId,
  ) async {
    try {
      final QueryOptions fetchOptions = QueryOptions(
        document: gql(r'''
          query($uId: String!, $pId: UUID!) {
            cartItemCollection(
              filter: { userId: { eq: $uId }, productId: { eq: $pId }, status: { eq: "created" }}, 
              orderBy: [{ createdAt: DescNullsLast }], 
              first: 1
            ) {
              edges { node { id } }
            }
          }
        '''),
        variables: {'uId': userId, 'pId': productId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final fetchResult = await retryer.retry(
        () => _client.query(fetchOptions),
      );
      final nodes =
          fetchResult.data?['cartItemCollection']['edges'] as List? ?? [];

      if (nodes.isEmpty) return false;

      final targetId = nodes.first['node']['id'];

      final MutationOptions deleteOptions = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) {
            deleteFromcartItemCollection(filter: { id: { eq: $id } }) { affectedCount }
          }
        '''),
        variables: {'id': targetId},
      );

      final deleteResult = await _mutateAndCheck(deleteOptions);
      final rowsDeleted =
          deleteResult.data?['deleteFromcartItemCollection']['affectedCount'] ??
          0;

      return rowsDeleted > 0;
    } catch (e) {
      rethrow;
    }
  }
}
