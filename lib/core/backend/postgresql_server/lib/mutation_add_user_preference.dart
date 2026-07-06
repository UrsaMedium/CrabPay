import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddUserPreference {
  final String? id;
  final String userId;
  final String favoriteProductId;

  MutationAddUserPreference({
    this.id,
    required this.userId,
    required this.favoriteProductId,
  });

  Future<void> execute() async {
    String query;
    Map<String, Object>? parameters;

    print('Adding user preference to db');

    if (id != null) {
      query =
          'INSERT INTO user_preference (id, user_id, favorite_product_id) VALUES (@id, @userId, @favoriteProductId)';
      parameters = {
        'id': id!,
        'userId': userId,
        'favoriteProductId': favoriteProductId,
      };
    } else {
      query =
          'INSERT INTO user_preference (user_id, favorite_product_id) VALUES (@userId, @favoriteProductId)';
      parameters = {'userId': userId, 'favoriteProductId': favoriteProductId};
    }

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Added user preference to db');
    } catch (e) {
      print('Failed to add user preference to db');
      rethrow;
    }
  }
}
