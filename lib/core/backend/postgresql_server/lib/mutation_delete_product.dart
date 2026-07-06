import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteProduct {
  final String id;

  MutationDeleteProduct({required this.id});

  Future<void> execute() async {
    print('Deleting product from db');

    const String query = 'DELETE FROM product WHERE id = @id';
    final Map<String, Object> parameters = {'id': id};

    try {
      await DbServer().execute(query, parameters: parameters);
    } catch (e) {
      rethrow;
    }
  }
}
