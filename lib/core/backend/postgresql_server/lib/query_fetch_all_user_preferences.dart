import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryGetUserPreferences {
  final String userId;

  QueryGetUserPreferences({required this.userId});
  Future<List<String>> execute() async {
    print('Fetching favorite product IDs for user: $userId');

    final String query = '''
      SELECT favorite_product_id 
      FROM user_preferences 
      WHERE user_id = @userId
    ''';

    try {
      final result = await DbServer().execute(
        query,
        parameters: {'userId': userId},
      );
      print('Fetched favorite product');
      return result.map((row) => row[0] as String).toList();
    } catch (e) {
      print('Failed to fetch favorite product');
      rethrow;
    }
  }
}
