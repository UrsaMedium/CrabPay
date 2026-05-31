import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart' show immutable;

enum DatabaseStates {
  initial,
  productFetched,
  productNotFetched,
  productFieldsFetched,
  productFieldsNotFetched,
  priceFunctionsFetched,
  priceFunctionsNotFetched,
  currenciesFetched,
  currenciesNotFetched
}

@immutable
class DatabaseState {
  final List<Product>? products;
  final List<Currencies>? currencies;
  final List<ProductField>? productFields;
  final List<PriceFunction>? priceFunctions;
  final DatabaseStates states;

  const DatabaseState({
    this.products,
    this.currencies,
    this.productFields,
    this.priceFunctions,
    this.states = DatabaseStates.initial,
  });

  DatabaseState copyWith({
    List<Product>? products,
    List<Currencies>? currencies,
    List<ProductField>? productFields,
    List<PriceFunction>? priceFunctions,
    DatabaseStates? states,
  }) {
    return DatabaseState(
      products: products ?? this.products,
      currencies: currencies ?? this.currencies,
      productFields: productFields,
      priceFunctions: priceFunctions,
      states: states ?? this.states,
    );
  }
}
