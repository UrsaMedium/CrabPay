import 'dart:convert';
import 'package:crabpay/core/backend/pyament_services/payment_server_conf.dart';
import 'package:http/http.dart' as http;

class PaymentOuterHandler {
  final String _vpsPaymentUrl = linkToThePaymentServer;

  Future<String> createPaymentLink({
    required List<String> cartItemIds,
    required double totalAmount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_vpsPaymentUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': totalAmount.toStringAsFixed(2),
          'cartItemIds': cartItemIds,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['paymentUrl'];
      } else {
        throw Exception('Server returned an error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate payment link: $e');
    }
  }
}
