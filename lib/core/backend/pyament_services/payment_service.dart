import 'dart:convert';
import 'package:crabpay/core/backend/pyament_services/payment_server_conf.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentOuterHandler {
  // Your VPS domain that routes through Nginx to your Node.js script
  final String _vpsPaymentUrl = linkToThePaymentServer;
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 1. Trigger Payment & Get the YooKassa Link
  /// Sends the cart items and total amount to your VPS to generate a checkout session.
  Future<String> createPaymentLink({
    required List<String> cartItemIds,
    required double totalAmount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_vpsPaymentUrl),
        headers: {'Content-Type': 'application/json'},
        // Using the exact payload structure your rewritten Node script expects
        body: jsonEncode({
          'amount': totalAmount.toStringAsFixed(2),
          'cartItemIds': cartItemIds,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Returns the YooKassa checkout URL
        return data['paymentUrl'];
      } else {
        throw Exception('VPS returned an error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate payment link: $e');
    }
  }

  /// 2. Listen for Database Transitions (Terminal States Only)
  /// Yields a result ONLY when the status officially resolves to 'paid' or 'failed'.
  Stream<String> listenToPaymentStatus(List<String> cartItemIds) {
    // Safety check to prevent crashing if an empty cart is passed
    if (cartItemIds.isEmpty) return const Stream.empty();

    // Because all items in this checkout session update simultaneously in the database,
    // watching just one item is enough to know when the entire payment succeeds or fails.
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
        // .distinct() prevents the stream from firing multiple times if the database
        // triggers an update but the 'status' string itself hasn't actually changed.
        .distinct()
        // .where() is the filter: The stream will stay completely silent and ignore
        // 'waiting for the payment'. It ONLY pushes data to your UI when it hits a final state.
        .where((status) => status == 'paid' || status == 'failed');
  }

  /// 3. Cleanup function to close the listener when the user leaves the checkout screen
  void disposeListener() {
    _supabase.removeAllChannels();
  }

  Future<String> paymentStatus(String anItem) async {
    try {
      final response = await _supabase
          .from(
            'cartItem',
          ) // Use 'cartItem' or 'cart_item' depending on your current schema
          .select('status')
          .eq('id', anItem)
          .single();
      return response['status'] as String;
    } catch (e) {
      rethrow;
    }
  }
}
