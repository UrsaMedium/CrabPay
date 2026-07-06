import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryGetAllCurrencies {
  Future<List<Currencies>> execute() async {
    print('Fetching all currencies');

    final String query = '''
      SELECT id, name, main_currency, rub, usd 
      FROM currencies
    ''';

    try {
      final result = await DbServer().execute(query);
      print('Fetched all currencies');
      return result.map((row) {
        return Currencies(
          id: row[0] as String,
          name: row[1] as String,
          mainCurrency: row[2] as String,
          rub: (row[3] as num).toDouble(),
          usd: (row[4] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch all currencies');
      rethrow;
    }
  }
}
