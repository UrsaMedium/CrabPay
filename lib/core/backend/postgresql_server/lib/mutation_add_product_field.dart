import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddProductField {
  final String productId;
  final int order;
  final Map<String, double>? priceImages;
  final List<String>? expectedData;
  final String handler;
  final String fieldName;
  final bool isPriceImage;

  MutationAddProductField({
    required this.productId,
    required this.order,
    this.priceImages,
    this.expectedData,
    required this.handler,
    required this.fieldName,
    required this.isPriceImage,
  });

  Future<void> execute() async {
    print('Adding new product field of product $productId');

    final List<String> columns = [
      'product_id',
      '"order"',
      'handler',
      'field_name',
      'is_price_image',
    ];

    final List<String> placeholders = [
      '@productId',
      '@order',
      '@handler',
      '@fieldName',
      '@isPriceImage',
    ];

    final Map<String, Object> parameters = {
      'productId': productId,
      'order': order,
      'handler': handler,
      'fieldName': fieldName,
      'isPriceImage': isPriceImage,
    };

    try {
      if (isPriceImage) {
        columns.add('price_images');
        placeholders.add('@priceImages');
        parameters['priceImages'] = priceImages!;
      }

      if (expectedData != null) {
        columns.add('expected_data');
        placeholders.add('@expectedData');
        parameters['expectedData'] = expectedData!;
      }

      final String query =
          '''
            INSERT INTO product_field (${columns.join(', ')})
            VALUES (${placeholders.join(', ')})
          ''';

      await DbServer().execute(query, parameters: parameters);
      print('Added new product field of product $productId');
    } catch (e) {
      print('Faild to add new product field of product $productId');
      rethrow;
    }
  }
}
