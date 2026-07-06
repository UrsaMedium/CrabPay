import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryGetUserCartCount {
  Future<int> execute({required String userId}) async {
    print('Fetching cart item count for user: $userId');

    final String query = '''
      SELECT user_cart_item_count 
      FROM user_cart_item_counters 
      WHERE user_id = @userId
    ''';

    try {
      final result = await DbServer().execute(
        query,
        parameters: {'userId': userId},
      );
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
