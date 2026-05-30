import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdminEvent {
  const AdminEvent();
}

class AdminEventAdminEnters extends AdminEvent {
  const AdminEventAdminEnters();
}

class AdminEventSubmitsProduct extends AdminEvent {
  final Product appProduct;
  const AdminEventSubmitsProduct({required this.appProduct});
}

class AdminEventSubmitsFields extends AdminEvent {
  final List<ProductField> appProductFields;
  const AdminEventSubmitsFields({required this.appProductFields});
}

class AdminEventSubmitsPriceDimensions extends AdminEvent {
  final Map<ProductField, String>? priceDimensions;
  const AdminEventSubmitsPriceDimensions({required this.priceDimensions});
}

class AdminEventEntersSpaceFillingView extends AdminEvent {
  final BuildContext context;
  const AdminEventEntersSpaceFillingView({required this.context});
}

class AdminEventSpaceFillingDataIsPrepared extends AdminEvent {
  const AdminEventSpaceFillingDataIsPrepared();
}

class AdminEventSubmitsPriceFunction extends AdminEvent {
  final Map<List<String>, double> priceFunction;
  const AdminEventSubmitsPriceFunction({required this.priceFunction});
}
