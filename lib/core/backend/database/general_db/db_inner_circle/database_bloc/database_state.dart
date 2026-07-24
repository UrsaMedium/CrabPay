import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:flutter/widgets.dart';

enum DatabaseStates {
  // initialization,
  dbLoading,
  initialized,
  notInitialized,
  flushedUserData,
  fail,
  //
  // productsBeingLoaded,
  productsFetched,
  productsNotFetched,
  //
  // fieldsBeingLoaded,
  fieldsFetched,
  fieldsNotFetched,
  //
  // currenciesBeingLoaded,
  currenciesFetched,
  currenciesNotFetched,
  //
  // featuedProductsBeingLoaded,
  featuedProductsFetched,
  featuedProductsNotFetched,
  //
  // userPreferencesBeingLoaded,
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
  // final List<ProductField>? productFields;
  final DatabaseStates states;
  final List<Product>? featuredProducts;
  final List<Product>? userPreferences;
  //
  final Map<String, List<ProductField>>? cachedProductFields;
  final Map<String, int>? cachedProductImageDominantColor;

  const DatabaseState({
    this.products,
    this.currencies,
    // this.productFields,
    this.states = DatabaseStates.dbLoading,
    this.featuredProducts,
    this.userPreferences,
    this.cachedProductFields,
    this.cachedProductImageDominantColor,
  });

  DatabaseState copyWith({
    List<Product>? products,
    List<Currencies>? currencies,
    // List<ProductField>? productFields,
    DatabaseStates? states,
    List<Product>? featuredProducts,
    List<Product>? userPreferences,
    //
    Map<String, List<ProductField>>? cachedProductFields,
    Map<String, int>? cachedProductImageDominantColor,
  }) {
    return DatabaseState(
      products: products ?? this.products,
      currencies:
          currencies ?? (this.currencies == [] ? null : this.currencies),
      // productFields:
      //     productFields ??
      //     (this.productFields == [] ? null : this.productFields),
      states: states ?? this.states,
      //
      featuredProducts: featuredProducts ?? this.featuredProducts,
      userPreferences: userPreferences ?? this.userPreferences,
      //
      cachedProductFields: cachedProductFields ?? this.cachedProductFields,
      cachedProductImageDominantColor:
          cachedProductImageDominantColor ??
          this.cachedProductImageDominantColor,
    );
  }
}
