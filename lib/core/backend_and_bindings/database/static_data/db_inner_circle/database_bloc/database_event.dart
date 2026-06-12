import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

// fetch all Poducts and theirs Fields
class DatabaseEventFetchAllProducts implements DatabaseEvent {}

// Product events
// add Product
class DatabaseEventAddProduct implements DatabaseEvent {
  final Product product;
  DatabaseEventAddProduct({required this.product});
}

// delete Product
class DatabaseEventDeleteProduct implements DatabaseEvent {
  final Product product;
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
  final String productFieldId;
  DatabaseEventFetchProductField({required this.productFieldId});
}

// add Product Field
class DatabaseEventAddProductField implements DatabaseEvent {
  final ProductField productField;
  DatabaseEventAddProductField({required this.productField});
}

// delete Product Field
class DatabaseEventDeleteProductField implements DatabaseEvent {
  final ProductField productField;
  DatabaseEventDeleteProductField({required this.productField});
}

// Currencies events
// fetch All Currencies
class DatabaseEventFetchAllCurrencies implements DatabaseEvent {}

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
