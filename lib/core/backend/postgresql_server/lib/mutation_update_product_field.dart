import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationUpdateProductField {
  final String id;
  final String? productId;
  final int? order;
  final String? fieldName;
  final bool? isPriceImage;
  final String? handler;
  final Map<String, double>?
  priceImages; // Adjusted type to handle string-double mapping
  final List<String>? expectedData;

  MutationUpdateProductField({
    required this.id,
    this.productId,
    this.order,
    this.fieldName,
    this.isPriceImage,
    this.handler,
    this.priceImages,
    this.expectedData,
  });

  Future<void> execute() async {
    print('Updating product field in db for id: $id');

    final List<String> updates = [];
    final Map<String, Object?> parameters = {'id': id};

    if (productId != null) {
      updates.add('product_id = @productId');
      parameters['productId'] = productId!;
    }
    if (order != null) {
      // "order" is a reserved keyword in PostgreSQL (e.g., ORDER BY).
      // Wrapping it in double quotes avoids SQL syntax issues.
      updates.add('"order" = @order');
      parameters['order'] = order!;
    }
    if (fieldName != null) {
      updates.add('field_name = @fieldName');
      parameters['fieldName'] = fieldName!;
    }
    if (isPriceImage != null) {
      updates.add('is_price_image = @isPriceImage');
      parameters['isPriceImage'] = isPriceImage!;
      if (!isPriceImage!) {
        updates.add('price_images = @priceImages');
        parameters['priceImages'] = null;
      }
    }
    if (handler != null) {
      updates.add('handler = @handler');
      parameters['handler'] = handler!;
    }
    if (priceImages != null) {
      updates.add('price_images = @priceImages');
      parameters['priceImages'] = priceImages!;
    }
    if (expectedData != null) {
      updates.add('expected_data = @expectedData');
      parameters['expectedData'] = expectedData!;
    }

    // Guard clause to prevent executing empty sets
    if (updates.isEmpty) {
      print('No fields provided for product field update execution.');
      return;
    }

    final String query =
        'UPDATE product_field SET ${updates.join(', ')} WHERE id = @id';

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Updated product field in db for id: $id');
    } catch (e) {
      print('Failed to update product field in db for id: $id');
    }
  }
}
