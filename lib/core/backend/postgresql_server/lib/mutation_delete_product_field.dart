import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteProductField {
  final String id;
  MutationDeleteProductField({required this.id});

  Future<void> execute() async {
    print('Deleting product field $id');
    const String query = 'DELETE FROM product_field WHERE id = @id';
    final Map<String, Object> parameters = {'id': id};

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Deleted product field $id');
    } catch (e) {
      print('Faild to delete product field $id');
      rethrow;
    }
  }
}
