import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

// fetch all Poducts and theirs Fields
class DatabaseEventFetchAllProductAndFieldsData implements DatabaseEvent {}

// Product events
// add Product
class DatabaseEventAddProduct implements DatabaseEvent {
  final AppProduct product;
  DatabaseEventAddProduct({required this.product});
}

// delete Product
class DatabaseEventDeleteProduct implements DatabaseEvent {
  final AppProduct product;
  DatabaseEventDeleteProduct({required this.product});
}

// Fields events
// fetch Product Fields
class DatabaseEventFetchProductFields implements DatabaseEvent {
  final String productId;
  DatabaseEventFetchProductFields({required this.productId});
}

// fetch Product Field
class DatabaseEventFetchProductField implements DatabaseEvent {
  final String productId;
  DatabaseEventFetchProductField({required this.productId});
}

// add Product Field
class DatabaseEventAddProductField implements DatabaseEvent {
  final AppProductField productField;
  DatabaseEventAddProductField({required this.productField});
}

// delete Product Field
class DatabaseEventDeleteProductField implements DatabaseEvent {
  final AppProductField productField;
  DatabaseEventDeleteProductField({required this.productField});
}

// Price Function events
// fetch Price Function
class DatabaseEventFetchPriceFunctions implements DatabaseEvent {
  final String productId;
  DatabaseEventFetchPriceFunctions({required this.productId});
}

// add Price Function
class DatabaseEventAddPriceFunction implements DatabaseEvent {
  final PriceFunction priceFunction;
  DatabaseEventAddPriceFunction({required this.priceFunction});
}

// delete Price Function
class DatabaseEventDeletePriceFunction implements DatabaseEvent {
  final PriceFunction priceFunction;
  DatabaseEventDeletePriceFunction({required this.priceFunction});
}

// Currencies events
// fetch All Currencies
class DatabaseEventFetchAllCurrencies implements DatabaseEvent {
  DatabaseEventFetchAllCurrencies();
}

// add Currencies
class DatabaseEventAddCurrencies implements DatabaseEvent {
  final Currencies currencies;
  DatabaseEventAddCurrencies({required this.currencies});
}

// delet Currencies
class DatabaseEventDeleteCurrencies implements DatabaseEvent {
  final Currencies currencies;
  DatabaseEventDeleteCurrencies({required this.currencies});
}
