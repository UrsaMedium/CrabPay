abstract class PaymentState {}

class PaymentStateSilence extends PaymentState {}

class PaymentStateLoading extends PaymentState {}

class PaymentStateUserAtProvider extends PaymentState {}

class PaymentStateListening extends PaymentState {}

class PaymentStatePaid extends PaymentState {}

class PaymentStateFailure extends PaymentState {}
