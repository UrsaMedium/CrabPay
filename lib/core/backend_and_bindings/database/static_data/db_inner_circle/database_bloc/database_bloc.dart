import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_state.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc(InnerDatabaseHandler databaseHandler)
    : super(const DatabaseState()) {
    //
    final _uuid = Uuid();

    //Initial call
    on<DatabaseEventInitialize>((event, emit) async {
      print('---');
      print('--- DatabaseEventInitialize fired');
      print('---');
      try {
        final products = await databaseHandler.fetchAllProductsForAdmin();
        final featuredProducts = await databaseHandler
            .fetchAllFeaturedProducts();
        final userPreferences = await databaseHandler.fetchUserPreferences(
          event.userId,
        );
        emit(
          state.copyWith(
            products: products,
            featuredProducts: featuredProducts,
            userPreferences: userPreferences,
          ),
        );
        emit(state.copyWith(states: DatabaseStates.initialized));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notInitialized));
        rethrow;
      }
    });

    // Products------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // fetch all Poducts
    on<DatabaseEventFetchAllProducts>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllProducts fired');
      print('---');
      try {
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

    // instantly fetch all Poducts for admin
    on<DatabaseEventFetchAllProductsForAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllProductsForAdmin fired');
      print('---');
      try {
        final products = await databaseHandler.fetchAllProductsForAdmin();
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

    // add Product
    on<DatabaseEventAddProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProduct fired');
      print('---');
      try {
        await databaseHandler.addProduct(event.product);
        emit(
          state.copyWith(
            recentlyAddedProduct: event.product,
            states: DatabaseStates.productAdded,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            recentlyAddedProduct: null,
            states: DatabaseStates.productNotAdded,
          ),
        );
        rethrow;
      }
    });

    // delete Product
    on<DatabaseEventDeleteProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteProduct fired');
      print('---');
      try {
        await databaseHandler.deleteProduct(event.product);
      } catch (e) {
        rethrow;
      }
    });

    // update a product
    on<DatabaseEventUpdateProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProduct fired');
      print('---');
      try {
        await databaseHandler.updateProduct(
          event.productId,
          event.imageName,
          event.productName,
          event.description,
        );
      } catch (e) {
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
        final productFields = await databaseHandler.fetchProductFields(
          event.productId,
        );
        emit(
          state.copyWith(
            productFields: productFields,
            states: DatabaseStates.productFieldsFetched,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.productFieldsNotFetched));
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

    // add Product Field
    on<DatabaseEventAddProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProductField fired');
      print('---');
      try {
        await databaseHandler.addProductField(event.productField);
      } catch (e) {
        rethrow;
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteProductField fired');
      print('---');
      try {
        await databaseHandler.deleteProductField(event.productField);
      } catch (e) {
        rethrow;
      }
    });

    // Currencies------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // fetch All Currencies
    on<DatabaseEventFetchAllCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventFetchAllCurrencies fired');
      print('---');
      try {
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
    // add Currencies
    on<DatabaseEventAddCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddCurrencies fired');
      print('---');
      try {
        await databaseHandler.addCurrencies(event.currencies);
      } catch (e) {
        rethrow;
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteCurrencies fired');
      print('---');
      try {
        await databaseHandler.deleteCurrencies(event.currencies);
      } catch (e) {
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
        final featuredProducts = await databaseHandler
            .fetchAllFeaturedProducts();
        emit(
          state.copyWith(
            featuredProducts: featuredProducts,
            states: DatabaseStates.fetchedFeatuedProducts,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notFeetchedFeatuedProducts));
        rethrow;
      }
    });

    //add featured product
    on<DatabaseEventAddFeaturedProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddFeaturedProduct fired');
      print('---');
      try {
        await databaseHandler.addFeaturedProduct(event.productId);
        emit(state.copyWith(states: DatabaseStates.addedFeatuedProducts));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notAddededFeatuedProducts));
        rethrow;
      }
    });

    on<DatabaseEventDeleteFeaturedProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteFeaturedProduct fired');
      print('---');
      try {
        await databaseHandler.deleteFeaturedProduct(event.productId);
        emit(state.copyWith(states: DatabaseStates.deletedFeatuedProducts));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notDeletedFeatuedProducts));
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
        final userPreferences = await databaseHandler.fetchUserPreferences(
          event.userId,
        );
        emit(
          state.copyWith(
            userPreferences: userPreferences,
            states: DatabaseStates.fetchedUserPreferebces,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notFetchedUserPreferebces));
        rethrow;
      }
    });

    //add user preference
    on<DatabaseEventAddUserPreference>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddUserPreference fired');
      print('---');
      try {
        await databaseHandler.addUserPreference(event.userId, event.productId);
        List<String> newPreference = state.userPreferences ?? [];
        newPreference.add(event.productId);
        emit(
          state.copyWith(
            userPreferences: newPreference,
            states: DatabaseStates.addedUserPreferences,
          ),
        );
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notAddedUserPreferences));
        rethrow;
      }
    });

    on<DatabaseEventDeleteUserPreference>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteUserPreference fired');
      print('---');
      try {
        await databaseHandler.deleteUserPreference(
          event.userId,
          event.productId,
        );
        List<String> deletedPreference = state.userPreferences ?? [];
        deletedPreference.removeWhere(
          (productId) => productId == event.productId,
        );
        emit(
          state.copyWith(
            userPreferences: deletedPreference,
            states: DatabaseStates.addedUserPreferences,
          ),
        );
        emit(state.copyWith(states: DatabaseStates.deletedUserPreferences));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.notDeletedUserPreferences));
        rethrow;
      }
    });
  }
}
