import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationUpdateProduct {
  final String id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? currencies;

  MutationUpdateProduct({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.currencies,
  });

  Future<void> execute() async {
    print('Updating product $id');
    final List<String> updateProductCommand = [];
    final Map<String, Object> parameters = {'id': id};

    if (name != null) {
      updateProductCommand.add('name = @name');
      parameters['name'] = name!;
    }
    if (description != null) {
      updateProductCommand.add('description = @description');
      parameters['description'] = description!;
    }
    if (imageUrl != null) {
      updateProductCommand.add('image_url = @imageUrl');
      parameters['imageUrl'] = imageUrl!;
    }
    if (currencies != null) {
      updateProductCommand.add('currencies = @currencies');
      parameters['currencies'] = currencies!;
    }

    if (updateProductCommand.isEmpty) {
      print('no data providet for the product');
      return;
    }

    final String query =
        'UPDATE product SET ${updateProductCommand.join(', ')} WHERE id = @id';

    try {
      await DbServer().execute(query, parameters: parameters);
    } catch (e) {
      rethrow;
    }
    print('The update is senct');
  }
}
