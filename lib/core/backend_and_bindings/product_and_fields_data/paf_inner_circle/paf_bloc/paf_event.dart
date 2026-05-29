import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class PafEvent {
  const PafEvent();
}

class PafEventFetchAllPAPData implements PafEvent {}

class PafEventAddProduct implements PafEvent {
  final AppProduct product;
  PafEventAddProduct({required this.product});
}

class PafEventDeleteProduct implements PafEvent {
  final AppProduct product;
  PafEventDeleteProduct({required this.product});
}

class PafEventAddProductField implements PafEvent {
  final AppProductField productField;
  PafEventAddProductField({required this.productField});
}

class PafEventDeleteProductField implements PafEvent {
  final AppProductField productField;
  PafEventDeleteProductField({required this.productField});
}
