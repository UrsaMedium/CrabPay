import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddFeaturedProduct {
  final String? id;
  final String featuredProductId;

  MutationAddFeaturedProduct({this.id, required this.featuredProductId});

  Future<void> execute() async {
    String query;
    Map<String, Object>? parameters;

    print('Adding featured product to db');

    if (id != null) {
      query =
          'INSERT INTO featured_product (id, featured_product_id) VALUES (@id, @featuredProductId)';
      parameters = {'id': id!, 'featuredProductId': featuredProductId};
    } else {
      query =
          'INSERT INTO featured_product (featured_product_id) VALUES (@featuredProductId)';
      parameters = {'featuredProductId': featuredProductId};
    }

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Added featured product to db');
    } catch (e) {
      print('Failed to add featured product to db');
      rethrow;
    }
  }
}
