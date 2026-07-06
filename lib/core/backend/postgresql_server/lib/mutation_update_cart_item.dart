import 'package:crabpay/core/backend/postgresql_server/db_server_worm_hole.dart';

class MutationUpdateCartItem {
  final String id;
  final String? userId;
  final String? userName;
  final String? productId;
  final String? productName;
  final Map<String, String>?
  purchaseData; // GraphQL 'Any' maps well to Object? for JSONB/JSON handling
  final String? currency;
  final double? checkoutPrice; // GraphQL 'Float' maps to Dart 'double'
  final String? status;
  final String? comment;
  final DateTime?
  statusChangedAt; // GraphQL 'Timestamp' maps to Dart 'DateTime'

  MutationUpdateCartItem({
    required this.id,
    this.userId,
    this.userName,
    this.productId,
    this.productName,
    this.purchaseData,
    this.currency,
    this.checkoutPrice,
    this.status,
    this.comment,
    this.statusChangedAt,
  });

  Future<void> execute() async {
    print('Updating cart item in db');

    // Track fields that are actually being updated
    final List<String> updates = [];
    final Map<String, Object> parameters = {'id': id};

    if (userId != null) {
      updates.add('user_id = @userId');
      parameters['userId'] = userId!;
    }
    if (userName != null) {
      updates.add('user_name = @userName');
      parameters['userName'] = userName!;
    }
    if (productId != null) {
      updates.add('product_id = @productId');
      parameters['productId'] = productId!;
    }
    if (productName != null) {
      updates.add('product_name = @productName');
      parameters['productName'] = productName!;
    }
    if (purchaseData != null) {
      updates.add('purchase_data = @purchaseData');
      parameters['purchaseData'] = purchaseData!;
    }
    if (currency != null) {
      updates.add('currency = @currency');
      parameters['currency'] = currency!;
    }
    if (checkoutPrice != null) {
      updates.add('checkout_price = @checkoutPrice');
      parameters['checkoutPrice'] = checkoutPrice!;
    }
    if (status != null) {
      updates.add('status = @status');
      parameters['status'] = status!;
    }
    if (comment != null) {
      updates.add('comment = @comment');
      parameters['comment'] = comment!;
    }
    if (statusChangedAt != null) {
      updates.add('status_changed_at = @statusChangedAt');
      parameters['statusChangedAt'] = statusChangedAt!;
    }

    if (updates.isEmpty) {
      print('No fields provided for update execution.');
      return;
    }

    // Build the dynamic query template
    final String query =
        'UPDATE cart_item SET ${updates.join(', ')} WHERE id = @id';

    try {
      await DbServer().execute(query, parameters: parameters);
      print('Updated cart item in db');
    } catch (e) {
      print('Failed to update cart item in db');
      rethrow;
    }
  }
}
