import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QueryFetchAllProducts {
  Future<List<Product>> execute() async {
    final String query = '''
      SELECT id, name, description, image_url, currencies
      FROM product
      ORDER BY name ASC;
    ''';
    try {
      final fetchedProducts = await DbServer().execute(query);
      if (fetchedProducts.isEmpty) return [];

      List<Product> convertedProduct = [];
      for (var prodcut in fetchedProducts) {
        convertedProduct.add(
          Product(
            id: prodcut[0] as String,
            name: prodcut[1] as String,
            description: prodcut[2] as String,
            image: prodcut[3] as String,
            currencies: prodcut[4] as String,
          ),
        );
      }

      return convertedProduct;
    } catch (e) {
      rethrow;
    }
  }
}
