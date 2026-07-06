import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteCurrencies {
  final String id;
  MutationDeleteCurrencies({required this.id});

  Future<void> execute() async {
    print('Deleting currency');
    const String query = 'DELETE FROM currencies WHERE id = @id';
    final Map<String, Object> parameters = {'id': id};
    try {
      await DbServer().execute(query, parameters: parameters);
      print('Deleted currency');
    } catch (e) {
      print('Failed to delete currency');
      rethrow;
    }
  }
}
