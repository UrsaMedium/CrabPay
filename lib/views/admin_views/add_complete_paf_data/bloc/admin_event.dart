import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AdminEvent {
  const AdminEvent();
}

class AdminEventAdminEnters extends AdminEvent {
  const AdminEventAdminEnters();
}

class AdminEventAdminSubmitsProduct extends AdminEvent {
  final AppProduct appProduct;
  const AdminEventAdminSubmitsProduct({required this.appProduct});
}

class AdminEventAdminSubmitsFields extends AdminEvent {
  final List<AppProductField> appProductFields;
  const AdminEventAdminSubmitsFields({required this.appProductFields});
}

class AdminEventAdminSubmitsPriceDimentions extends AdminEvent {
  final Map<AppProductField, bool>? priceDimentions;
  const AdminEventAdminSubmitsPriceDimentions({required this.priceDimentions});
}

class AdminEventAdminSubmitsPriceSpace extends AdminEvent {
  const AdminEventAdminSubmitsPriceSpace();
}
