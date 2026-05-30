import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc(InnerDatabaseHandler databaseHandler)
    : super(const DatabaseStateDataNotFetched()) {
    //
    // fetch all Poducts and theirs Fields
    on<DatabaseEventFetchAllProducts>((event, emit) async {
      // showLoading(event.context);
      try {
        await databaseHandler.fetchAllProducts(event.context);
        emit(DatabaseStateDataFetched());
      } catch (e) {
        emit(DatabaseStateDataNotFetched()); //TODO
      }
    });

    // Products
    // add Product
    on<DatabaseEventAddProduct>((event, emit) async {
      try {
        await databaseHandler.addProduct(event.product);
      } catch (_) {
        rethrow; //TODO
      }
    });

    // delete Product
    on<DatabaseEventDeleteProduct>((event, emit) async {
      try {
        await databaseHandler.deleteProduct(event.product);
      } catch (_) {
        //TODO
      }
    });

    // Fields
    // fetch Product Fields
    on<DatabaseEventFetchProductFields>((event, emit) async {
      try {
        await databaseHandler.fetchProductFields(
          event.productId,
          event.context,
        );
      } catch (_) {
        //TODO
      }
    });

    // fetch Product Field
    on<DatabaseEventFetchProductField>((event, emit) async {
      try {
        await databaseHandler.fetchProductField(
          event.productFieldId,
          event.context,
        );
      } catch (_) {
        //TODO
      }
    });

    // add Product Field
    on<DatabaseEventAddProductField>((event, emit) async {
      try {
        await databaseHandler.addProductField(event.productField);
      } catch (_) {
        rethrow; //TODO
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductField>((event, emit) async {
      try {
        await databaseHandler.deleteProductField(event.productField);
      } catch (_) {
        rethrow; //TODO
      }
    });

    // Price Functions
    // fetch Price Function
    on<DatabaseEventFetchPriceFunctions>((event, emit) async {
      try {
        await databaseHandler.fetchPriceFunctions(
          event.productId,
          event.context,
        );
      } catch (_) {
        //TODO
      }
    });
    // add Price Function
    on<DatabaseEventAddPriceFunction>((event, emit) async {
      try {
        await databaseHandler.addPriceFunction(event.priceFunction);
      } catch (_) {
        //TODO
      }
    });
    // delete Price Function
    on<DatabaseEventDeletePriceFunction>((event, emit) async {
      try {
        await databaseHandler.deletePriceFunction(event.priceFunction);
      } catch (_) {
        //TODO
      }
    });
    // Currencies
    // fetch All Currencies
    on<DatabaseEventFetchAllCurrencies>((event, emit) async {
      try {
        await databaseHandler.fetchAllCurencies(event.context);
      } catch (_) {
        //TODO
      }
    });
    // add Currencies
    on<DatabaseEventAddCurrencies>((event, emit) async {
      try {
        await databaseHandler.addCurrencies(event.currencies);
      } catch (_) {
        //TODO
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrencies>((event, emit) async {
      try {
        await databaseHandler.deleteCurrencies(event.currencies);
      } catch (_) {
        //TODO
      }
    });
  }
}
