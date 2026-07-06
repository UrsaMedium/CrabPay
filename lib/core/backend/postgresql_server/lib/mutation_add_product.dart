import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddProduct {
  final String? id;
  final String name;
  final String description;
  final String imageUrl;
  final String currencies;
  MutationAddProduct({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.currencies,
  });

  Future<void> execute() async {
    String query;
    Map<String, Object>? parameters;
    print('Pushing product to db');
    if (id != null) {
      query =
          'INSERT INTO product (id, name, description, image_url, currencies) VALUES (@id, @name, @description, @imageUrl, @currencies)';
      parameters = {
        'id': id!,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'currencies': currencies,
      };
    } else {
      query =
          'INSERT INTO product (name, description, image_url, currencies) VALUES (@name, @description, @imageUrl, @currencies)';
      parameters = {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'currencies': currencies,
      };
    }

    try {
      await DbServer().execute(query, parameters: parameters);
    } catch (e) {
      rethrow;
    }
  }
}
