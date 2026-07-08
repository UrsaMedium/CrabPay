import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
// import 'package:uuid/uuid.dart';
// import 'package:uuid/v4.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc(InnerDatabaseHandler databaseHandler)
    : super(const DatabaseState()) {
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
        final featuredProducts = await databaseHandler
            .fetchAllFeaturedProducts();
        List<String> userPreferences = [];
        if (!event.currentUser.isAnonymous) {
          userPreferences = await databaseHandler.fetchUserPreferences(
            userId: event.currentUser.id,
          );
        }
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

    on<DatabaseEventFlushData>((event, emit) {
      try {
        emit(
          state.copyWith(
            productFields: null,
            userPreferences: null,
            currencies: null,
            featuredProducts: null,
            products: null,
            recentlyAddedProduct: null,
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

    // add Product
    on<DatabaseEventAddProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.addProduct(product: event.product);
        emit(
          state.copyWith(
            recentlyAddedProduct: event.product,
            states: DatabaseStates.productsAdded,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            recentlyAddedProduct: null,
            states: DatabaseStates.productsNotAdded,
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
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.deleteProduct(product: event.product);
        emit(state.copyWith(states: DatabaseStates.productsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.productsNotDeleted));
        rethrow;
      }
    });

    // update a product
    on<DatabaseEventUpdateProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.updateProduct(
          productId: event.productId,
          imageName: event.imageName,
          productName: event.productName,
          description: event.description,
        );
        emit(state.copyWith(states: DatabaseStates.productsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.productsNotUpdated));
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

    // add Product Field
    on<DatabaseEventAddProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProductField fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.addProductField(field: event.productField);
        emit(state.copyWith(states: DatabaseStates.fieldsAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fieldsNotAdded));
        rethrow;
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteProductField fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.deleteProductField(field: event.productField);
        emit(state.copyWith(states: DatabaseStates.fieldsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fieldsNotDeleted));
        rethrow;
      }
    });

    on<DatabaseEventUpdateProductField>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProductFieldUpdateNameAndOrder fired');
      print('---');
      emit(state.copyWith(states: DatabaseStates.dbLoading));
      try {
        await databaseHandler.updateProductField(
          fieldId: event.field.id,
          order: event.field.order,
          fieldName: event.field.fieldName,
          isPriceImage: event.field.isPriceImage,
          priceImages:
              event.field.isPriceImage && event.field.handler == 'InputField'
              ? {
                  event.field.priceImages!.keys.first:
                      event.field.priceImages!.values.first,
                }
              : event.field.priceImages,
          expectedData: (event.field.handler == 'InputField')
              ? [event.field.fieldName]
              : event.field.expectedData,
        );
        emit(state.copyWith(states: DatabaseStates.fieldsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fieldsNotUpdated));
        rethrow;
      }
    });

    on<DatabaseEventUpdateProductFieldSwapImageField>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProductFieldSwapImageField fired');
      print('---');
      emit(state.copyWith(states: DatabaseStates.dbLoading));
      try {
        if (event.oldImageField != null) {
          await databaseHandler.updateProductField(
            fieldId: event.oldImageField!.id,
            isPriceImage: false,
            priceImages: null,
          );
        }
        await databaseHandler.updateProductField(
          fieldId: event.newImageField.id,
          isPriceImage: true,
          priceImages: null,
        );
        emit(state.copyWith(states: DatabaseStates.fieldsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.fieldsNotUpdated));
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
    // add Currencies
    on<DatabaseEventAddCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddCurrencies fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.addCurrencies(currencies: event.currencies);
        emit(state.copyWith(states: DatabaseStates.currenciesAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.currenciesNotAdded));
        rethrow;
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrencies>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteCurrencies fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.deleteCurrencies(currencies: event.currencies);
        emit(state.copyWith(states: DatabaseStates.currenciesDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.currenciesNotDeleted));
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
        final featuredProducts = await databaseHandler
            .fetchAllFeaturedProducts();
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

    //add featured product
    on<DatabaseEventAddFeaturedProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddFeaturedProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.addFeaturedProduct(productId: event.productId);
        emit(state.copyWith(states: DatabaseStates.featuedProductsAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.featuedProductsNotAdded));
        rethrow;
      }
    });

    on<DatabaseEventDeleteFeaturedProduct>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteFeaturedProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStates.dbLoading));
        await databaseHandler.deleteFeaturedProduct(productId: event.productId);
        emit(state.copyWith(states: DatabaseStates.featuedProductsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStates.featuedProductsNotDeleted));
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
        final userPreferences = await databaseHandler.fetchUserPreferences(
          userId: event.userId,
        );
        emit(
          state.copyWith(
            userPreferences: userPreferences,
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
          productId: event.productId,
        );
        List<String> newPreference = state.userPreferences ?? [];
        newPreference.add(event.productId);
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
          productId: event.productId,
        );
        List<String> deletedPreference = state.userPreferences ?? [];
        deletedPreference.removeWhere(
          (productId) => productId == event.productId,
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
  }
}
