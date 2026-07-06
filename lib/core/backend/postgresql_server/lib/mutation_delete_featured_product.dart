import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationDeleteFeaturedProduct {
  final String featuredProductId;

  MutationDeleteFeaturedProduct({required this.featuredProductId});

  Future<void> execute() async {
    print('Deleting featured product allocation from db');

    const String query =
        'DELETE FROM featured_product WHERE featured_product_id = @featuredProductId';

    final Map<String, Object> parameters = {
      'featuredProductId': featuredProductId,
    };

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Deleted featured product allocation from db');
    } catch (e) {
      print('Failed to delete featured product allocation from db');
    }
  }
}
