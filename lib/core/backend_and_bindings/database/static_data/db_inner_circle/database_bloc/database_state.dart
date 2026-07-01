import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart' show immutable;

enum DatabaseStates {
  initial,
  initialized,
  notInitialized,
  //
  productsFetched,
  productsNotFetched,
  productAdded,
  productNotAdded,
  productDeleted,
  productNotDeleted,
  //
  productFieldsFetched,
  productFieldsNotFetched,
  //
  currenciesFetched,
  currenciesNotFetched,
  //
  fetchedFeatuedProducts,
  notFeetchedFeatuedProducts,
  addedFeatuedProducts,
  notAddededFeatuedProducts,
  deletedFeatuedProducts,
  notDeletedFeatuedProducts,
  //
  fetchedUserPreferebces,
  notFetchedUserPreferebces,
  addedUserPreferences,
  notAddedUserPreferences,
  deletedUserPreferences,
  notDeletedUserPreferences,

  //
}

@immutable
class DatabaseState {
  final List<Product>? products;
  final List<Currencies>? currencies;
  final List<ProductField>? productFields;
  final DatabaseStates states;
  final List<String>? featuredProducts;
  final List<String>? userPreferences;
  final Product? recentlyAddedProduct;

  const DatabaseState({
    this.products,
    this.currencies,
    this.productFields,
    this.states = DatabaseStates.initial,
    this.recentlyAddedProduct,
    this.featuredProducts,
    this.userPreferences,
  });

  DatabaseState copyWith({
    List<Product>? products,
    List<Currencies>? currencies,
    List<ProductField>? productFields,
    DatabaseStates? states,
    Product? recentlyAddedProduct,
    List<String>? featuredProducts,
    List<String>? userPreferences,
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
      featuredProducts: featuredProducts ?? this.featuredProducts,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }
}
