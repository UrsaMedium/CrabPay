import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteLastAddedProductCartItem {
  final String userId;
  final String productId;

  MutationDeleteLastAddedProductCartItem({
    required this.userId,
    required this.productId,
  });

  Future<void> execute() async {
    print(
      'Deleting last added cart item for user $userId and product $productId',
    );

    // Named parameters isolate inputs safely from the SQL structural logic
    final String query = '''
      DELETE FROM cart_item
      WHERE id = (
        SELECT id
        FROM cart_item
        WHERE user_id = @userId AND product_id = @productId
        ORDER BY created_at DESC
        LIMIT 1
      )
    ''';

    final Map<String, Object> parameters = {
      'userId': userId,
      'productId': productId,
    };

    try {
      await DbServer().execute(query, parameters: parameters);
      print(
        'Deleted last added cart item for user $userId and product $productId',
      );
    } catch (e) {
      print(
        'Failed to delete last added cart item for user $userId and product $productId',
      );
    }
  }
}
