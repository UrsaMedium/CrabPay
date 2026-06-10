import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
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
  final DatabaseStates states;
  //
  final Product? recentlyAddedProduct;

  const DatabaseState({
    this.products,
    this.currencies,
    this.productFields,
    this.states = DatabaseStates.initial,
    //
    this.recentlyAddedProduct,
  });

  DatabaseState copyWith({
    List<Product>? products,
    List<Currencies>? currencies,
    List<ProductField>? productFields,
    DatabaseStates? states,
    //
    Product? recentlyAddedProduct,
  }) {
    return DatabaseState(
      products: products ?? this.products,
      currencies:
          currencies ?? (this.currencies == [] ? null : this.currencies),
      productFields:
          productFields ??
          (this.productFields == [] ? null : this.productFields),
      states: states ?? this.states,
      //
      recentlyAddedProduct: recentlyAddedProduct,
    );
  }
}
