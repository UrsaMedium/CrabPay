import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc(InnerDatabaseHandler databaseHandler)
    : super(const DatabaseState()) {
    //
    // fetch all Poducts and theirs Fields
    on<DatabaseEventFetchAllProducts>((event, emit) async {
      // showLoading(event.context);
      try {
        final products = await databaseHandler.fetchAllProducts();
        emit(
          state.copyWith(
            products: products,
            states: DatabaseStates.productsFetched,
          ),
        );
      } catch (e) {
        // Fluttertoast.showToast(msg: 'Faild to fetch products $e');
        // print('Faild to fetch products $e');
        // emit(state.copyWith(states: DatabaseStates.productsNotFetched));
        rethrow;
      }
    });

    // Products
    // add Product
    on<DatabaseEventAddProduct>((event, emit) async {
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
        // print('Failed to add product $e');
        // Fluttertoast.showToast(msg: 'Failed to add product $e');
        rethrow;
      }
    });

    // delete Product
    on<DatabaseEventDeleteProduct>((event, emit) async {
      try {
        await databaseHandler.deleteProduct(event.product);
      } catch (e) {
        // print('Failed to delete product $e');
        // Fluttertoast.showToast(msg: 'Failed to delete product $e');
        rethrow;
      }
    });

    // Fields
    // fetch Product Fields
    on<DatabaseEventFetchProductFields>((event, emit) async {
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
        // print('Failed to fetch product fields $e');
        // Fluttertoast.showToast(msg: 'Failed to fetch product fields $e');
        emit(state.copyWith(states: DatabaseStates.productFieldsNotFetched));
        rethrow;
      }
    });

    // fetch Product Field
    on<DatabaseEventFetchProductField>((event, emit) async {
      // TODO
    });

    // add Product Field
    on<DatabaseEventAddProductField>((event, emit) async {
      try {
        await databaseHandler.addProductField(event.productField);
      } catch (e) {
        // print('Faild to add field $e');
        // Fluttertoast.showToast(msg: 'Faild to add field $e');
        rethrow;
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductField>((event, emit) async {
      try {
        await databaseHandler.deleteProductField(event.productField);
      } catch (e) {
        // print('Faild to delete field $e');
        // Fluttertoast.showToast(msg: 'Faild to delete field $e');
        rethrow;
      }
    });

    // Currencies
    // fetch All Currencies
    on<DatabaseEventFetchAllCurrencies>((event, emit) async {
      try {
        final allCurrencies = await databaseHandler.fetchAllCurencies();
        emit(
          state.copyWith(
            currencies: allCurrencies,
            states: DatabaseStates.currenciesFetched,
          ),
        );
      } catch (e) {
        // print('Failed to fetch currencies $e');
        // Fluttertoast.showToast(msg: 'Failed to fetch currencies $e');
        emit(state.copyWith(states: DatabaseStates.currenciesNotFetched));
        rethrow;
      }
    });
    // add Currencies
    on<DatabaseEventAddCurrencies>((event, emit) async {
      try {
        await databaseHandler.addCurrencies(event.currencies);
      } catch (e) {
        // print('Faild to add currencies $e');
        // Fluttertoast.showToast(msg: 'Faild to add currencies $e');
        rethrow;
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrencies>((event, emit) async {
      try {
        await databaseHandler.deleteCurrencies(event.currencies);
      } catch (e) {
        // print('Faild to delete currencies $e');
        // Fluttertoast.showToast(msg: 'Faild to delete currencies $e');
        rethrow;
      }
    });
  }
}
