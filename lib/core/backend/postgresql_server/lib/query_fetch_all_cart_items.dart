import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';
// Import your existing CartItem model here if needed

class QueryGetCartItems {
  Future<List<CartItem>> execute({required String userId}) async {
    print('Fetching cart items for user ID: $userId');

    // Index mapping:
    // row[0]=id, row[1]=user_id, row[2]=user_name, row[3]=product_id, row[4]=product_name
    // row[5]=purchase_data, row[6]=currency, row[7]=checkout_price, row[8]=status, row[9]=comment
    final String query = '''
      SELECT 
        id, 
        user_id, 
        user_name, 
        product_id, 
        product_name, 
        purchase_data, 
        currency, 
        checkout_price, 
        status, 
        comment
      FROM cart_items
      WHERE user_id = @userId
    ''';

    try {
      final result = await DbServer().execute(
        query,
        parameters: {'userId': userId},
      );
      print('Fetched cart items');
      return result.map((row) {
        final rawJsonMap = row[5] as Map<String, dynamic>? ?? {};
        final parsedPurchaseData = rawJsonMap.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        );

        return CartItem(
          id: row[0] as String,
          userId: row[1] as String,
          userName: row[2] as String,
          productId: row[3] as String,
          productName: row[4] as String,
          purchaseData: parsedPurchaseData,
          currency: row[6] as String,
          checkoutPrice: (row[7] as num).toDouble(),
          status: row[8] as String,
          comment: row[9] as String?,
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch cart items');
      rethrow;
    }
  }
}
