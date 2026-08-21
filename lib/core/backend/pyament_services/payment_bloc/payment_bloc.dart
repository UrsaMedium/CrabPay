import 'dart:developer' as developer;

import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_event.dart';
import 'package:crabpay/core/backend/pyament_services/payment_bloc/payment_state.dart';
import 'package:crabpay/core/backend/pyament_services/payment_service.dart';
import 'package:crabpay/core/local_storage/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(PaymentOuterHandler paymentHandler)
    : super(PaymentStateSilence()) {
    on<PaymentEventPay>((event, emit) async {
      developer.log('----');
      developer.log('CartEventOnPayCall fired');
      developer.log('----');
      emit(PaymentStateLoading());
      try {
        double totalAmount = 0;
        List<String> cartItemIds = [];
        for (var item in event.cartItems) {
          cartItemIds.add(item.id);
          totalAmount += item.checkoutPrice;
        }
        final String paymentUrl = await paymentHandler.createPaymentLink(
          cartItemIds: cartItemIds,
          totalAmount: totalAmount,
        );
        AppLocalStorage.savePaymentLink(paymentUrl);
        final Uri url = Uri.parse(paymentUrl);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Failed to launch $paymentUrl');
        }
        emit(PaymentStateUserAtProvider());
      } catch (e) {
        developer.log('--- Payment error: $e');
        rethrow;
      }
    });

    on<PaymentEventReturnToProvider>((event, emit) async {
      developer.log('----');
      developer.log('PaymentEventReturnToProvider fired');
      developer.log('----');
      try {
        final Uri url = Uri.parse(event.link);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Failed to launch ${event.link}');
        }
        emit(PaymentStateUserAtProvider());
      } catch (e) {
        developer.log('--- Payment error: $e');
        rethrow;
      }
    });
  }
}
