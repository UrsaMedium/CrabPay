import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryGetFeaturedProducts {
  Future<List<String>> execute() async {
    print('Fetching all featured products');

    final String query = '''
      SELECT id, featured_product_id 
      FROM featured_products
    ''';

    List<String> featuredProducts = [];
    try {
      final result = await DbServer().execute(query);
      for (var row in result) {
        featuredProducts.add(row[1] as String);
      }
      print('Fetched all featured products');
      return featuredProducts;
    } catch (e) {
      print('Failed to fetch all featured products');
      rethrow;
    }
  }
}
