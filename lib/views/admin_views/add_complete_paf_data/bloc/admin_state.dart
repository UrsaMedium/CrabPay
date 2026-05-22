import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/pap_inner_circle/product_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AdminState {
  final AppProduct? appProduct;
  final List<AppProductField>? appProductFields;
  final Map<AppProductField, bool>? priceDimentions;
  const AdminState({
    this.priceDimentions,
    this.appProduct,
    this.appProductFields,
  });
}

class AdminStateNoAdmin extends AdminState {
  const AdminStateNoAdmin();
}

class AdminStateSubmitedProduct extends AdminState {
  const AdminStateSubmitedProduct({required super.appProduct});
}

class AdminStateSubmitedFields extends AdminState {
  const AdminStateSubmitedFields({required super.appProductFields});
}

class AdminStateSubmitedDimentions extends AdminState {
  const AdminStateSubmitedDimentions({required super.priceDimentions});
}
