import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteUserPreference {
  final String userId;
  final String favoriteProductId;

  MutationDeleteUserPreference({
    required this.userId,
    required this.favoriteProductId,
  });

  Future<void> execute() async {
    print('Deleting user preference from db');

    const String query =
        'DELETE FROM user_preference WHERE user_id = @userId AND favorite_product_id = @favoriteProductId';

    final Map<String, Object> parameters = {
      'userId': userId,
      'favoriteProductId': favoriteProductId,
    };

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Deleted user preference from db');
    } catch (e) {
      print('Failed to delete user preference from db');
      rethrow;
    }
  }
}
