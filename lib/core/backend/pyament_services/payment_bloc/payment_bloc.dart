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

    on<PaymentEventListen>((event, emit) async {
      developer.log('----');
      developer.log('PaymentEventListen fired');
      developer.log('----');
      emit(PaymentStateListening());
      try {
        List<String> cartItemIds = [];
        for (var item in event.cartItems) {
          cartItemIds.add(item.id);
        }
        await emit.forEach<String>(
          paymentHandler.listenToPaymentStatus(cartItemIds),
          onData: (status) {
            if (status == 'paid') {
              developer.log('--- Paid');
              return PaymentStatePaid();
            } else if (status == 'failed') {
              developer.log('--- No Payment');
              return PaymentStateFailure();
            }
            developer.log('listenning');
            return PaymentStateListening();
          },
          onError: (error, stackTrace) {
            developer.log('--- Payment error: ${error.toString()}');
            return PaymentStateFailure();
          },
        );
      } catch (e) {
        developer.log('--- Payment error: $e');
        emit(PaymentStateFailure());
        rethrow;
      }
    });

    on<PaymentEventOnAppBackToLive>((event, emit) async {
      developer.log('----');
      developer.log('PaymentEventOnAppBackToLive fired');
      developer.log('----');
      emit(PaymentStateListening());
      if (event.cartItemIds.isEmpty) {
        emit(PaymentStateSilence());
        return;
      }
      try {
        paymentHandler.disposeListener();
        final status = await paymentHandler.paymentStatus(
          event.cartItemIds.first,
        );
        developer.log(status);
        if (status != 'waiting for the payment') {
          await emit.forEach<String>(
            paymentHandler.listenToPaymentStatus(event.cartItemIds),
            onData: (status) {
              if (status == 'paid') {
                developer.log('--- Paid');
                return PaymentStatePaid();
              } else if (status == 'failed') {
                developer.log('--- No Payment');
                return PaymentStateFailure();
              }
              developer.log('listenning');

              return PaymentStateListening();
            },
            onError: (error, stackTrace) {
              developer.log('some error: ${error.toString()}');
              return PaymentStateFailure();
            },
          );
        } else {
          if (status == 'paid') {
            developer.log('--- Paid');
            emit(PaymentStatePaid());
          } else if (status == 'failed') {
            developer.log('--- No Payment');
            emit(PaymentStateFailure());
          }
        }
      } catch (e) {
        developer.log('--- Payment error: $e');
        emit(PaymentStateFailure());
        rethrow;
      }
    });

    on<PaymentEventSilence>((event, emit) {
      paymentHandler.disposeListener();
      emit(PaymentStateSilence());
    });
  }
}
