import 'dart:convert';
import 'dart:async';
import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/common/paginated_result_data_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/inner_cart_handler.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/supabase/supabase_graphql_client.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retry/retry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OuterCartHandlerWithSupabase implements InnerCartHandler {
  final GraphQLClient _client = SupabaseGraphQLClient.client;
  final retryer = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(milliseconds: 500),
  );

  //streaming---------------------------------------------
  StreamSubscription? _appLifecycleSub;
  StreamSubscription? _supabaseSubToStreamUserCartItemAmount;
  StreamSubscription? _pendingOrderSub;
  String? _activeUserId;

  final _userCartItemAmountController = StreamController<int>.broadcast();
  final _pendingOrderController =
      StreamController<List<PendingOrder>>.broadcast();

  final AppLifecycleService _appLifecycleService;
  OuterCartHandlerWithSupabase({
    required AppLifecycleService appLifecycleService,
  }) : _appLifecycleService = appLifecycleService {
    _initAppLifecycleService();
  }

  void _initAppLifecycleService() {
    _appLifecycleSub = _appLifecycleService.appStateStream.listen((state) {
      if (state == AppState.active && _activeUserId != null) {
        _connectToPendingOrder(_activeUserId!);
        _connectToSupabase(_activeUserId!);
      } else if (state == AppState.paused) {
        _disconnectFromSupabase();
        _closeSubPendingOrders();
      }
    });
  }

  @override
  Stream<List<PendingOrder>> streamPendingOrders(String userId) {
    _activeUserId = userId;
    _closeSubPendingOrders();
    _connectToPendingOrder(userId);

    return _pendingOrderController.stream;
  }

  void _connectToPendingOrder(String userId) {
    if (_pendingOrderSub != null) return;

    try {
      final supabase = Supabase.instance.client;
      _pendingOrderSub = supabase
          .from('user_pending_payments_table')
          .stream(primaryKey: ['paymentId', 'userId'])
          .eq('userId', userId)
          .map<List<PendingOrder>>((rows) {
            if (rows.isEmpty) return [];
            List<PendingOrder> pendingOrders = [];
            for (var row in rows) {
              pendingOrders.add(
                PendingOrder(
                  paymentId: row['paymentId'],
                  userId: row['userId'],
                  paymentLink: row['paymentLink'],
                  totalPrice: 0,
                  cartItems: [],
                ),
              );
            }
            return pendingOrders;
          })
          .handleError(
            (Object error) => _userCartItemAmountController.addError(error),
          )
          .listen(
            (pendingOrders) => _pendingOrderController.add(pendingOrders),
            onError: (e) => _pendingOrderController.addError(e),
          );
    } catch (e) {
      _pendingOrderController.addError(e);
    }
  }

  void _closeSubPendingOrders() {
    _pendingOrderSub?.cancel();
    _pendingOrderSub = null;
  }

  @override
  Stream<int> streamUserCartItemAmount(String userId) {
    _activeUserId = userId;

    _disconnectFromSupabase();
    _connectToSupabase(userId);

    return _userCartItemAmountController.stream;
  }

  void _connectToSupabase(String userId) {
    if (_supabaseSubToStreamUserCartItemAmount != null) return;

    try {
      final supabase = Supabase.instance.client;

      _supabaseSubToStreamUserCartItemAmount = supabase
          .from('ofUserCartItemCounter')
          .stream(primaryKey: ['userId'])
          .eq('userId', userId)
          .map((List<Map<String, dynamic>> rows) {
            if (rows.isEmpty) return 0;
            final rawCount = rows.first['userCartItemCount'];
            return (rawCount as num?)?.toInt() ?? 0;
          })
          .handleError((Object error, StackTrace stackTrace) {
            getIt<InnerLoggerHandler>().recordException(
              error:
                  'Runtime WebSocket Error in userCartItemAmountStream: $error',
              stackTrace: stackTrace,
            );
            _userCartItemAmountController.addError(error);
          })
          .listen(
            (itemCount) {
              _userCartItemAmountController.add(itemCount);
            },
            onError: (error) {
              _userCartItemAmountController.addError(error);
            },
          );
    } catch (e) {
      _userCartItemAmountController.addError(e);
    }
  }

  void _disconnectFromSupabase() {
    _supabaseSubToStreamUserCartItemAmount?.cancel();
    _supabaseSubToStreamUserCartItemAmount = null;
  }

  void dispose() {
    _disconnectFromSupabase();
    _appLifecycleSub?.cancel();
    _userCartItemAmountController.close();
    _pendingOrderController.close();
    _pendingOrderSub?.cancel();
    _supabaseSubToStreamUserCartItemAmount?.cancel();
  }
  //streaming---------------------------------------------

  Future<QueryResult> _mutateAndCheck(MutationOptions options) async {
    return await retryer.retry(() async {
      final result = await _client.mutate(options);

      if (result.hasException) {
        debugPrint(
          'Supabase Cart GraphQL Error: ${result.exception.toString()}',
        );
        throw Exception(result.exception.toString());
      }
      return result;
    });
  }

  List<CartItem> _dataCasting(List<dynamic> edges) {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Data casting',
        category: 'Cart Items',
        data: {'edges': edges},
      );
      return edges.map((edge) {
        final item = edge['node'];
        final dynamic rawPurchaseData = item['purchaseData'] ?? {};
        final dynamic rawCreatedAt = item['createdAt'];
        final dynamic rawStatusChangedAt = item['statusChangedAt'];

        DateTime? paredCreatedAt;
        DateTime? parsedStatusChangedAt;

        if (rawCreatedAt != null &&
            rawCreatedAt is String &&
            rawCreatedAt.isNotEmpty) {
          paredCreatedAt = DateTime.parse(rawCreatedAt).toLocal();
        }

        if (rawStatusChangedAt != null &&
            rawStatusChangedAt is String &&
            rawStatusChangedAt.isNotEmpty) {
          parsedStatusChangedAt = DateTime.parse(rawStatusChangedAt).toLocal();
        }

        final Map<String, dynamic> decodedPurchaseData =
            rawPurchaseData is String
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
          paymentId: item['paymentId'],
          paymentLink: item['paymentLink'],
          createdAt: paredCreatedAt ?? DateTime(0),
          statusChangedAt: parsedStatusChangedAt,
        );
      }).toList();
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed datacasting',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> fetchCartItemsToBuy(String userId) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetching cart items',
        category: 'Cart Items',
        data: {'userId': userId},
      );
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($userId: String!) {
            cartItemCollection(
              first: 128, 
              orderBy: [{ createdAt: DescNullsLast }],
              filter: { 
                userId: { eq: $userId }, 
                status: { in: ["created", "failed"] } 
              }
            ) {
              edges {
                node { id, userId, userName, productId, productName, purchaseData, currency, checkoutPrice, status, comment, paymentId }
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to fetch cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch cart items');
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<String>> fetchNotDeliveredOrdersIds(
    String userId, {
    String? pageToken,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetching paginated unique payment IDs',
        category: 'Order History',
        data: {'userId': userId, 'pageToken': pageToken},
      );

      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($userId: String!, $afterCursor: Cursor) {
            userUniquePaymentCollection(
              first: 4,
              after: $afterCursor,
              orderBy: [{ latestCreatedAt: DescNullsLast }],
              filter: { 
                userId: { eq: $userId }
                status: { neq: "delivered" }
              }
            ) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node { 
                  paymentId 
                }
              }
            }
          }
        '''),
        variables: {'userId': userId, 'afterCursor': pageToken},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final collection = result.data?['userUniquePaymentCollection'] ?? {};
      final pageInfo = collection['pageInfo'] ?? {};
      final edges = collection['edges'] as List? ?? [];

      final List<String> paymentIds = edges
          .map((edge) => edge['node']['paymentId'] as String?)
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();

      return PaginatedResult<String>(
        objects: paymentIds,
        hasMore: (pageInfo['hasNextPage'] as bool?) ?? false,
        nextPageToken: pageInfo['endCursor'] as String?,
      );
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to fetch unique payment IDs',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to load order history');
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<String>> fetchSearchedOrdersIds({
    required String userId,
    String? pageToken,
    DateTime? fromDate,
    DateTime? toDate,
    String? orderId,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetching filtered unique payment IDs',
        category: 'Order History',
        data: {
          'userId': userId,
          'pageToken': pageToken,
          'fromDate': fromDate?.toIso8601String(),
          'toDate': toDate?.toIso8601String(),
          'orderId': orderId,
        },
      );

      int currentOffset = 0;
      if (pageToken != null && pageToken.isNotEmpty) {
        currentOffset = int.tryParse(pageToken) ?? 0;
      }

      final StringBuffer signatureVariables = StringBuffer(
        '\$userId: String!, \$offset: Int!',
      );
      final StringBuffer filterBlock = StringBuffer('userId: { eq: \$userId }');

      final Map<String, dynamic> variables = {
        'userId': userId,
        'offset': currentOffset,
      };

      if (orderId != null && orderId.trim().isNotEmpty) {
        signatureVariables.write(', \$orderId: String!');
        filterBlock.write(', paymentId: { eq: \$orderId }');
        variables['orderId'] = orderId.trim();
      }

      if (fromDate != null || toDate != null) {
        filterBlock.write(', latestCreatedAt: { ');

        if (fromDate != null) {
          signatureVariables.write(', \$fromDate: Datetime!');
          filterBlock.write('gte: \$fromDate ');
          variables['fromDate'] = fromDate.toUtc().toIso8601String();
        }

        if (toDate != null) {
          if (fromDate != null) filterBlock.write(', ');
          signatureVariables.write(', \$toDate: Datetime!');
          filterBlock.write('lte: \$toDate ');
          variables['toDate'] = toDate.toUtc().toIso8601String();
        }

        filterBlock.write('}');
      }

      final String queryDocument =
          '''
        query(${signatureVariables.toString()}) {
          userUniquePaymentCollection(
            first: 500,
            offset: \$offset,
            orderBy: [{ latestCreatedAt: DescNullsLast }],
            filter: {
              ${filterBlock.toString()}
            }
          ) {
            edges {
              node {
                paymentId
              }
            }
          }
        }
      ''';

      final QueryOptions options = QueryOptions(
        document: gql(queryDocument),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final collection = result.data?['userUniquePaymentCollection'] ?? {};
      final edges = collection['edges'] as List? ?? [];

      final List<String> paymentIds = edges
          .map((edge) => edge['node']['paymentId'] as String?)
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();

      // 6. Calculate manual pagination bounds based on offset length
      final bool hasMore = edges.length == 4;
      final String? nextToken = hasMore ? (currentOffset + 4).toString() : null;

      return PaginatedResult<String>(
        objects: paymentIds,
        hasMore: hasMore,
        nextPageToken: nextToken,
      );
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to fetch filtered unique payment IDs',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to filter order history');
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<String>> fetchDeliveredOrdersIds(
    String userId, {
    String? pageToken,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetching paginated unique payment IDs',
        category: 'Order History',
        data: {'userId': userId, 'pageToken': pageToken},
      );

      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($userId: String!, $afterCursor: Cursor) {
            userUniquePaymentCollection(
              first: 4,
              after: $afterCursor,
              orderBy: [{ latestCreatedAt: DescNullsLast }],
              filter: { 
                userId: { eq: $userId }
                status: { eq: "delivered" }
              }
            ) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node { 
                  paymentId 
                }
              }
            }
          }
        '''),
        variables: {'userId': userId, 'afterCursor': pageToken},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final collection = result.data?['userUniquePaymentCollection'] ?? {};
      final pageInfo = collection['pageInfo'] ?? {};
      final edges = collection['edges'] as List? ?? [];

      final List<String> paymentIds = edges
          .map((edge) => edge['node']['paymentId'] as String?)
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();

      return PaginatedResult<String>(
        objects: paymentIds,
        hasMore: (pageInfo['hasNextPage'] as bool?) ?? false,
        nextPageToken: pageInfo['endCursor'] as String?,
      );
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to fetch unique payment IDs',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to load order history');
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> fetchItemsOfOrder(
    String userId,
    String orderId,
  ) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Fetching Items Of Order',
        category: 'Cart Items',
        data: {'userId': userId, 'orderId': orderId},
      );
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($userId: String!, $orderId: String!) {
            cartItemCollection(
              first: 128, 
              orderBy: [{ createdAt: DescNullsLast }],
              filter: { 
                userId: { eq: $userId },
                paymentId: { eq: $orderId }
              }
            ) {
              edges {
                node { 
                  id, 
                  userId, 
                  userName, 
                  productId, 
                  productName, 
                  purchaseData, 
                  currency, 
                  checkoutPrice, 
                  status, 
                  comment, 
                  paymentId,
                  createdAt,
                  statusChangedAt
                }
              }
            }
          }
        '''),
        variables: {'userId': userId, 'orderId': orderId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final nodes = result.data?['cartItemCollection']['edges'] as List? ?? [];
      return _dataCasting(nodes);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to fetch cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to fetch cart items');
      rethrow;
    }
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Deleting na item',
        category: 'Cart Items',
        data: {'cartItemId': cartItemId},
      );
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation($id: UUID!) { deleteFromcartItemCollection(filter: { id: { eq: $id } }) { affectedCount } }
        '''),
        variables: {'id': cartItemId},
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to delete cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
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
          'purchaseData': jsonEncode(cartItem.purchaseData),
          'currency': cartItem.currency,
          'checkoutPrice': cartItem.checkoutPrice,
          'status': cartItem.status,
          'comment': cartItem.comment,
        },
      );
      await _mutateAndCheck(options);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to add cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      Fluttertoast.showToast(msg: 'Failed to add the cart item');
      rethrow;
    }
  }

  @override
  Future<void> updateCartItem(
    List<CartItem> cartItems,
    AppAuthUser? user,
  ) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Updating cart item',
        category: 'Cart Items',
        data: {'user': user, 'cartItems': cartItems},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to update cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  @override
  Future<int> getProductCartItemAmount(String userId, String productId) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Getting Product Cart Item Amount',
        category: 'Cart Items',
        data: {'userId': userId, 'productId': productId},
      );
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

      if (result.hasException) {
        debugPrint(
          'GraphQL Query Error (Product Cart Count): ${result.exception.toString()}',
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to get product cart items amount',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  @override
  Future<bool> deleteLastAddedProductCartItem(
    String userId,
    String productId,
  ) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Deleting Last Added Product Cart Item',
        category: 'Cart Items',
        data: {'userId': userId, 'productId': productId},
      );
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
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to delete last added cart items',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> fetchPendingCartItems(String paymentId) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query($paymentId: String!) {
            cartItemCollection(
              first: 128, 
              orderBy: [{ createdAt: DescNullsLast }],
              filter: { 
                paymentId: { eq: $paymentId },
              }
            ) {
              edges {
                node { id, userId, userName, productId, productName, purchaseData, currency, checkoutPrice, status, comment, paymentId, paymentLink }
              }
            }
          }
        '''),
        variables: {'paymentId': paymentId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await retryer.retry(() => _client.query(options));
      if (result.hasException) throw result.exception!;

      final nodes = result.data?['cartItemCollection']['edges'] as List? ?? [];
      return _dataCasting(nodes);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch pending orders cart items');
      rethrow;
    }
  }
}
