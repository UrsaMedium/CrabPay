import 'package:flutter/material.dart' show immutable;

enum DatabaseStatesAdmin {
  // initialization,
  dbLoading,
  initialized,
  notInitialized,
  flushed,
  fail,
  //
  // productsBeingLoaded,
  productsFetched,
  productsNotFetched,
  productsAdded,
  productsNotAdded,
  productsDeleted,
  productsNotDeleted,
  productsUpdated,
  productsNotUpdated,
  //
  // fieldsBeingLoaded,
  fieldsFetched,
  fieldsNotFetched,
  fieldsAdded,
  fieldsNotAdded,
  fieldsDeleted,
  fieldsNotDeleted,
  fieldsUpdated,
  fieldsNotUpdated,
  //
  // currenciesBeingLoaded,
  currenciesFetched,
  currenciesNotFetched,
  currenciesAdded,
  currenciesNotAdded,
  currenciesDeleted,
  currenciesNotDeleted,
  currenciesUpdated,
  currenciesNotUpdated,
  //
  // featuedProductsBeingLoaded,
  featuedProductsFetched,
  featuedProductsNotFetched,
  featuedProductsAdded,
  featuedProductsNotAdded,
  featuedProductsDeleted,
  featuedProductsNotDeleted,
  featuedProductsUpdated,
  featuedProductsNotUpdated,
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
class DatabaseStateAdmin {
  final DatabaseStatesAdmin states;

  const DatabaseStateAdmin({
    this.states = DatabaseStatesAdmin.dbLoading,
  });

  DatabaseStateAdmin copyWith({
    DatabaseStatesAdmin? states,
  }) {
    return DatabaseStateAdmin(
      states: states ?? this.states,
    );
  }
}
