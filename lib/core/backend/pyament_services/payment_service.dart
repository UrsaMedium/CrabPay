import 'dart:convert';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/backend/pyament_services/payment_server_conf.dart';
import 'package:crabpay/main.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentOuterHandler {
  final String _vpsPaymentUrl = linkToThePaymentServer;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> createPaymentLink({
    required List<String> cartItemIds,
    required double totalAmount,
  }) async {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'Creating Payment Link',
      category: 'Payemnt',
      data: {'cartItemIds': cartItemIds, 'totalAmount': totalAmount},
    );
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
        getIt<InnerLoggerHandler>().recordException(
          error: 'Server returned an error',
          stackTrace: StackTrace.fromString('${response.statusCode}'),
        );
        throw Exception('Server returned an error: ${response.body}');
      }
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to generate a payment link',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      throw Exception('Failed to generate payment link: $e');
    }
  }

  Stream<String> listenToPaymentStatus(List<String> cartItemIds) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'Listenning Payment Link',
      category: 'Payemnt',
      data: {'cartItemIds': cartItemIds},
    );
    if (cartItemIds.isEmpty) return const Stream.empty();

    try {
      final targetId = cartItemIds.first;

      return _supabase
          .from('cartItem')
          .stream(primaryKey: ['id'])
          .eq('id', targetId)
          .map((List<Map<String, dynamic>> data) {
            if (data.isNotEmpty) {
              return data.first['status'] as String? ?? 'unknown';
            }

            return 'unknown';
          })
          .distinct()
          .where((status) => status == 'paid' || status == 'failed');
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to set up a listen channel',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }

  void disposeListener() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'Disposing listenner',
      category: 'Payemnt',
    );
    _supabase.removeAllChannels();
  }

  Future<String> paymentStatus(String anItem) async {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'Payment status',
      category: 'Payemnt',
      data: {'anItem': anItem},
    );
    try {
      final response = await _supabase
          .from('cartItem')
          .select('status')
          .eq('id', anItem)
          .single();
      return response['status'] as String;
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed to get payment status',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      rethrow;
    }
  }
}
