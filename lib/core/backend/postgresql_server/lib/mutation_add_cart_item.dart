import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationAddCartItem {
  final String? id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final Map<String, String> purchaseData;
  final String currency;
  final double checkoutPrice;
  final String status;
  final String? comment;

  MutationAddCartItem({
    this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.purchaseData,
    required this.currency,
    required this.checkoutPrice,
    required this.status,
    this.comment,
  });

  Future<void> execute() async {
    print('Adding cart item to db');

    final List<String> columns = [];
    final List<String> placeholders = [];
    final Map<String, Object> parameters = {};

    if (id != null) {
      columns.add('id');
      placeholders.add('@id');
      parameters['id'] = id!;
    }

    columns.addAll([
      'user_id',
      'user_name',
      'product_id',
      'product_name',
      'purchase_data',
      'currency',
      'checkout_price',
      'status',
    ]);
    placeholders.addAll([
      '@userId',
      '@userName',
      '@productId',
      '@productName',
      '@purchaseData',
      '@currency',
      '@checkoutPrice',
      '@status',
    ]);
    parameters.addAll({
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'productName': productName,
      'purchaseData': purchaseData,
      'currency': currency,
      'checkoutPrice': checkoutPrice,
      'status': status,
    });

    if (comment != null) {
      columns.add('comment');
      placeholders.add('@comment');
      parameters['comment'] = comment!;
    }

    final String query =
        'INSERT INTO cart_item (${columns.join(', ')}) VALUES (${placeholders.join(', ')})';

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Added cart item to db');
    } catch (e) {
      print('Failed to add cart item to db');
      rethrow;
    }
  }
}
