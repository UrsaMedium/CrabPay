import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class PapEvent {
  const PapEvent();
}

class PapEventFetchAllPAPData implements PapEvent {}

class PapEventAddProduct implements PapEvent {
  final AppProduct product;
  PapEventAddProduct({required this.product});
}

class PapEventDeleteProduct implements PapEvent {
  final AppProduct product;
  PapEventDeleteProduct({required this.product});
}

class PapEventAddProductProperty implements PapEvent {
  final AppProductProperty productProperty;
  PapEventAddProductProperty({required this.productProperty});
}

class PapEventDeleteProductProperty implements PapEvent {
  final AppProductProperty productProperty;
  PapEventDeleteProductProperty({required this.productProperty});
}
