import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  final String baseUrl = 'https://regred-rainbowbridge.ru/api/payments';

  Future<String?> createPayment({
    required String orderId,
    required String amount,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/create');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'orderId': orderId, 'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['paymentUrl'] as String?;
      } else {
        print('Server Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Network Error occurred: $e');
      rethrow;
    }
  }

  Future<bool> launchPaymentUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      return true;
    } else {
      print('Cloud not launch payment URL: $urlString');
      return false;
    }
  }
}
