import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddCurrencies {
  final String name;
  final String mainCurrency;
  final double rub;
  final double usd;
  MutationAddCurrencies({
    required this.name,
    required this.mainCurrency,
    required this.rub,
    required this.usd,
  });

  Future<void> execute() async {
    print('Adding new currency');
    const String query = '''
      INSERT INTO currencies (name, main_currency, rub, usd)
      VALUES (@name, @mainCurrency, @rub, @usd)
    ''';

    final Map<String, Object> parameters = {
      'name': name,
      'mainCurrency': mainCurrency,
      'rub': rub,
      'usd': usd,
    };

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Added new currency');
    } catch (e) {
      print('Faild to add new currency');
      rethrow;
    }
  }
}
