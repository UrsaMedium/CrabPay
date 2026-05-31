import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart' show immutable;

enum DatabaseStates {
  initial,
  productsFetched,
  productsNotFetched,
  productFieldsFetched,
  productFieldsNotFetched,
  priceFunctionsFetched,
  priceFunctionsNotFetched,
  currenciesFetched,
  currenciesNotFetched,
  //
  productAdded,
  productNotAdded,
}

@immutable
class DatabaseState {
  final List<Product>? products;
  final List<Currencies>? currencies;
  final List<ProductField>? productFields;
  final List<PriceFunction>? priceFunctions;
  final DatabaseStates states;
  //
  final Product? recentlyAddedProduct;

  const DatabaseState({
    this.products,
    this.currencies,
    this.productFields,
    this.priceFunctions,
    this.states = DatabaseStates.initial,
    //
    this.recentlyAddedProduct,
  });

  DatabaseState copyWith({
    List<Product>? products,
    List<Currencies>? currencies,
    List<ProductField>? productFields,
    List<PriceFunction>? priceFunctions,
    DatabaseStates? states,
    //
    Product? recentlyAddedProduct,
  }) {
    return DatabaseState(
      products: products ?? this.products,
      currencies: currencies ?? this.currencies,
      productFields: productFields,
      priceFunctions: priceFunctions,
      states: states ?? this.states,
      //
      recentlyAddedProduct: recentlyAddedProduct,
    );
  }
}
