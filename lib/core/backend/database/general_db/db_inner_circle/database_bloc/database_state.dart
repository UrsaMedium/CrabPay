import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart' show immutable;

enum DatabaseStates {
  initialization,
  initialized,
  notInitialized,
  flushed,
  fail,
  //
  productsBeingLoaded,
  productsFetched,
  productsNotFetched,
  productsAdded,
  productsNotAdded,
  productsDeleted,
  productsNotDeleted,
  productsUpdated,
  productsNotUpdated,
  //
  fieldsBeingLoaded,
  fieldsFetched,
  fieldsNotFetched,
  fieldsAdded,
  fieldsNotAdded,
  fieldsDeleted,
  fieldsNotDeleted,
  fieldsUpdated,
  fieldsNotUpdated,
  //
  currenciesBeingLoaded,
  currenciesFetched,
  currenciesNotFetched,
  currenciesAdded,
  currenciesNotAdded,
  currenciesDeleted,
  currenciesNotDeleted,
  currenciesUpdated,
  currenciesNotUpdated,
  //
  featuedProductsBeingLoaded,
  featuedProductsFetched,
  featuedProductsNotFetched,
  featuedProductsAdded,
  featuedProductsNotAdded,
  featuedProductsDeleted,
  featuedProductsNotDeleted,
  featuedProductsUpdated,
  featuedProductsNotUpdated,
  //
  userPreferencesBeingLoaded,
  userPreferencesFetched,
  userPreferencesNotFetched,
  userPreferencesAdded,
  userPreferencesNotAdded,
  userPreferencesDeleted,
  userPreferencesNotDeleted,
  userPreferencesUpdated,
  userPreferencesNotUpdated,
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
    this.states = DatabaseStates.initialization,
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
