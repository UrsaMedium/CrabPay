import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryGetProductCartCount {
  Future<int> execute({
    required String userId,
    required String productId,
  }) async {
    print('Fetching cart item count for user: $userId, product: $productId');

    // Mapping compound conditions and fields to proper snake_case PostgreSQL format
    final String query = '''
      SELECT product_cart_item_count 
      FROM user_product_cart_item_counters 
      WHERE user_id = @userId AND product_id = @productId
    ''';

    try {
      final result = await DbServer().execute(
        query,
        parameters: {'userId': userId, 'productId': productId},
      );
      print('Fetched cart item count');

      if (result.isEmpty) {
        return 0;
      }

      return (result.first[0] as num).toInt();
    } catch (e) {
      print('Failed to fetch cart item count');
      rethrow;
    }
  }
}
