import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteCartItem {
  final String id;
  MutationDeleteCartItem({required this.id});

  Future<void> execute() async {
    print('Deleting cart item field $id');
    const String query = 'DELETE FROM cart_item WHERE id = @id';
    final Map<String, Object> parameters = {'id': id};

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Deleted cart item field $id');
    } catch (e) {
      print('Faild to cart item product field $id');
      rethrow;
    }
  }
}
