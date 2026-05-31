import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            states: DatabaseStates.productFetched,
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to fetch products $e');
        emit(state.copyWith(states: DatabaseStates.productNotFetched));
      }
    });

    // Products
    // add Product
    on<DatabaseEventAddProduct>((event, emit) async {
      try {
        await databaseHandler.addProduct(event.product);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to add product $e');
      }
    });

    // delete Product
    on<DatabaseEventDeleteProduct>((event, emit) async {
      try {
        await databaseHandler.deleteProduct(event.product);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to delete product $e');
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
        Fluttertoast.showToast(msg: 'Failed to fetch product fields $e');
        emit(state.copyWith(states: DatabaseStates.productFieldsNotFetched));
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
        Fluttertoast.showToast(msg: 'Faild to add field $e');
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductField>((event, emit) async {
      try {
        await databaseHandler.deleteProductField(event.productField);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to delete field $e');
      }
    });

    // Price Functions
    // fetch Price Function
    on<DatabaseEventFetchPriceFunctions>((event, emit) async {
      try {
        final priceFunctions = await databaseHandler.fetchPriceFunctions(
          event.productId,
        );
        emit(
          state.copyWith(
            priceFunctions: priceFunctions,
            states: DatabaseStates.priceFunctionsFetched,
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to fetch price functions $e');
        emit(state.copyWith(states: DatabaseStates.priceFunctionsNotFetched));
      }
    });
    // add Price Function
    on<DatabaseEventAddPriceFunction>((event, emit) async {
      try {
        await databaseHandler.addPriceFunction(event.priceFunction);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to add price function $e');
      }
    });
    // delete Price Function
    on<DatabaseEventDeletePriceFunction>((event, emit) async {
      try {
        await databaseHandler.deletePriceFunction(event.priceFunction);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to delete price function $e');
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
        Fluttertoast.showToast(msg: 'Failed to fetch currencies $e');
        emit(state.copyWith(states: DatabaseStates.currenciesNotFetched));
      }
    });
    // add Currencies
    on<DatabaseEventAddCurrencies>((event, emit) async {
      try {
        await databaseHandler.addCurrencies(event.currencies);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to add currencies $e');
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrencies>((event, emit) async {
      try {
        await databaseHandler.deleteCurrencies(event.currencies);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Faild to delete currencies $e');
      }
    });
  }
}
