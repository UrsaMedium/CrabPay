import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class QuieryFetchProductFields {
  final String productId;

  QuieryFetchProductFields({required this.productId});

  Future<List<ProductField>> execute() async {
    print('Fetching productfields of the product $productId');

    const String query = '''
      SELECT product_id, id, "order", field_name, is_price_image, handler, price_images, expected_data 
      FROM product_field 
      WHERE product_id = @productId
    ''';

    final Map<String, Object> parameters = {'productId': productId};

    try {
      final result = await DbServer().execute(query, parameters: parameters);

      return result.map((row) {
        final columns = row.toColumnMap();
        Map<String, double>? parsedPriceImages;
        if (columns['is_price_image'] && columns['price_images'] != null) {
          final rawMap = columns['price_images'] as Map<dynamic, dynamic>;
          parsedPriceImages = rawMap.map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          );
        }

        List<String>? parsedExpectedData;
        if (columns['expected_data'] != null) {
          parsedExpectedData = (columns['expected_data'] as List)
              .cast<String>();
        }
        print('Fetched productfields of the product $productId');
        return ProductField(
          id: columns['id'] as String,
          productId: columns['product_id'] as String,
          order: columns['order'] as int,
          fieldName: columns['field_name'] as String,
          isPriceImage: columns['is_price_image'] as bool,
          handler: columns['handler'] as String,
          priceImages: parsedPriceImages,
          expectedData: parsedExpectedData,
        );
      }).toList();
    } catch (e) {
      print('Failed to fetched productfields of the product $productId');
      rethrow;
    }
  }
}
