import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
// import 'package:uuid/uuid.dart';
// import 'package:uuid/v4.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  DatabaseBloc({
    required InnerDatabaseHandler databaseHandler,
    required AuthInnerInterface authInnerface,
  }) : _authInterface = authInnerface,
       super(const DatabaseState()) {
    //
    // final _uuid = Uuid();

    //Initial call------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<DatabaseEventInitialize>((event, emit) async {
      print('---');
      print('--- DatabaseEventInitialize fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        final products = await databaseHandler.fetchAllProducts();
        final featuredProductIds = await databaseHandler
            .fetchAllFeaturedProducts();
        List<String> userPreferenceProductIds = [];
        if (!event.currentUser.isAnonymous) {
          userPreferenceProductIds = await databaseHandler.fetchUserPreferences(
            userId: event.currentUser.id,
          );
        }

        List<Product> featuredProducts = [];
        for (var productId in featuredProductIds) {
          featuredProducts.add(
            products!.firstWhere((product) => product.id == productId),
          );
        }
        List<Product> userPreferenceProducts = [];
        for (var productId in userPreferenceProductIds) {
          userPreferenceProducts.add(
            products!.firstWhere((product) => product.id == productId),
          );
        }
        emit(
          state.copyWith(
            products: products,
            featuredProducts: featuredProducts,
            userPreferences: userPreferenceProducts,
          ),
        );
        emit(state.copyWith(states: DatabaseStates.initialized));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notInitialized));
        rethrow;
      }
    });

    on<DatabaseEventFlushData>((event, emit) {
      try {
        emit(
          state.copyWith(
            productFields: null,
            userPreferences: null,
            currencies: null,
            featuredProducts: null,
            products: null,
            states: DatabaseStates.flushed,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fail));
        rethrow;
      }
    });

    // Products------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // fetch all Poducts
    on<DatabaseEventFetchAllProducts>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllProductsForAdmin fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        final products = await databaseHandler.fetchAllProducts();
        emit(
          state.copyWith(
            products: products,
            states: DatabaseStates.productsFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.productsNotFetched));
        rethrow;
      }
    });

    // Fields------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // fetch Product Fields
    on<DatabaseEventFetchProductFields>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchProductFields fired');
      print('---');
      try {
        emit(
          state.copyWith(productFields: null, states: DatabaseStates.dbLoading),
        );
        final productFields = await databaseHandler.fetchProductFields(
          productId: event.productId,
        );
        emit(
          state.copyWith(
            productFields: productFields,
            states: DatabaseStates.fieldsFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fieldsNotFetched));
        rethrow;
      }
    });

    // fetch Product Field
    on<DatabaseEventFetchProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchProductField fired');
      print('---');
      // TODO
    });

    // Currencies------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // fetch All Currencies
    on<DatabaseEventFetchAllCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllCurrencies fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        final allCurrencies = await databaseHandler.fetchAllCurencies();
        emit(
          state.copyWith(
            currencies: allCurrencies,
            states: DatabaseStates.currenciesFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.currenciesNotFetched));
        rethrow;
      }
    });

    //Featured Products ---------------------------------------------------------------------------------------------------------------
    //fetch all featured products
    on<DatabaseEventFetchAllFeaturedProducts>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllFeaturedProducts fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        final featuredProductIds = await databaseHandler
            .fetchAllFeaturedProducts();
        List<Product> featuredProducts = [];
        for (var productId in featuredProductIds) {
          featuredProducts.add(
            state.products!.firstWhere((product) => product.id == productId),
          );
        }

        emit(
          state.copyWith(
            featuredProducts: featuredProducts,
            states: DatabaseStates.featuedProductsFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.featuedProductsNotFetched));
        rethrow;
      }
    });

    //User Preferences -------------------------------------------------------------------------------------------
    //fetch user preferences
    on<DatabaseEventFetchUserPreferences>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchUserPreferences fired');
      print('---');
      try {
        emit(
          state.copyWith(
            userPreferences: null,
            states: DatabaseStates.dbLoading,
          ),
        );
        final userPreferenceIds = await databaseHandler.fetchUserPreferences(
          userId: event.userId,
        );
        List<Product> userPreferenceProducts = [];
        for (var productId in userPreferenceIds) {
          userPreferenceProducts.add(
            state.products!.firstWhere((product) => product.id == productId),
          );
        }
        emit(
          state.copyWith(
            userPreferences: userPreferenceProducts,
            states: DatabaseStates.userPreferencesFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.userPreferencesNotFetched));
        rethrow;
      }
    });

    //add user preference
    on<DatabaseEventAddUserPreference>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddUserPreference fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.addUserPreference(
          userId: event.userId,
          productId: event.product.id,
        );
        List<Product> newPreference = state.userPreferences ?? [];
        newPreference.add(event.product);
        emit(
          state.copyWith(
            userPreferences: newPreference,
            states: DatabaseStates.userPreferencesAdded,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.userPreferencesNotAdded));
        rethrow;
      }
    });

    on<DatabaseEventDeleteUserPreference>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteUserPreference fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.deleteUserPreference(
          userId: event.userId,
          productId: event.product.id,
        );
        List<Product> deletedPreference = state.userPreferences ?? [];
        deletedPreference.removeWhere(
          (product) => product.id == event.product.id,
        );
        emit(
          state.copyWith(
            userPreferences: deletedPreference,
            states: DatabaseStates.userPreferencesDeleted,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.userPreferencesNotDeleted));
        rethrow;
      }
    });

    _authSubscription = _authInterface.userStream.listen((user) {
      add(DatabaseEventFlushData());
      add(DatabaseEventInitialize(currentUser: user));
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
