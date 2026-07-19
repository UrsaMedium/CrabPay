import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_event.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_state.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_inner_database_handler.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
// import 'package:uuid/uuid.dart';
// import 'package:uuid/v4.dart';

class DatabaseBlocAdmin extends Bloc<DatabaseEventAdmin, DatabaseStateAdmin> {
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  DatabaseBlocAdmin({
    required AdminInnerDatabaseHandler databaseHandlerAdmin,
    required AuthInnerInterface authInnerface,
  }) : _authInterface = authInnerface,
       super(const DatabaseStateAdmin()) {
    //
    // final _uuid = Uuid();

   

    // Products------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

    // add Product
    on<DatabaseEventAddProductAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.addProductAdmin(product: event.product);
        emit(
          state.copyWith(
            states: DatabaseStatesAdmin.productsAdded,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            states: DatabaseStatesAdmin.productsNotAdded,
          ),
        );
        rethrow;
      }
    });

    // delete Product
    on<DatabaseEventDeleteProductAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.deleteProductAdmin(product: event.product);
        emit(state.copyWith(states: DatabaseStatesAdmin.productsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.productsNotDeleted));
        rethrow;
      }
    });

    // update a product
    on<DatabaseEventUpdateProductAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.updateProductAdmin(product: event.product);
        emit(state.copyWith(states: DatabaseStatesAdmin.productsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.productsNotUpdated));
        rethrow;
      }
    });

    // Fields------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




    // add Product Field
    on<DatabaseEventAddProductFieldAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddProductField fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.addProductFieldAdmin(field: event.productField);
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsNotAdded));
        rethrow;
      }
    });

    // delete Product Field
    on<DatabaseEventDeleteProductFieldAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteProductField fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.deleteProductFieldAdmin(field: event.productField);
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsNotDeleted));
        rethrow;
      }
    });

    on<DatabaseEventUpdateProductFieldAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProductField fired');
      print('---');
      emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
      try {
        await databaseHandlerAdmin.updateProductFieldAdmin(field: event.field);
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsNotUpdated));
        rethrow;
      }
    });

    on<DatabaseEventUpdateProductFieldSwapImageFieldAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventUpdateProductFieldSwapImageField fired');
      print('---');
      emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
      try {
        if (event.oldImageField != null) {
          final oldChangedField = ProductField(
            id: event.oldImageField!.id,
            productId: event.oldImageField!.productId,
            order: event.oldImageField!.order,
            fieldName: event.oldImageField!.fieldName,
            handler: event.oldImageField!.handler,
            isPriceImage: false,
            expectedData: event.oldImageField!.expectedData,
            priceImages: null,
          );
          await databaseHandlerAdmin.updateProductFieldAdmin(field: oldChangedField);
        }
        final newChangedField = ProductField(
          id: event.newImageField.id,
          productId: event.newImageField.productId,
          order: event.newImageField.order,
          fieldName: event.newImageField.fieldName,
          handler: event.newImageField.handler,
          isPriceImage: true,
          expectedData: event.newImageField.expectedData,
          priceImages: null,
        );
        await databaseHandlerAdmin.updateProductFieldAdmin(field: newChangedField);
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsUpdated));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.fieldsNotUpdated));
        rethrow;
      }
    });

    // Currencies------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    // add Currencies
    on<DatabaseEventAddCurrenciesAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddCurrencies fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin .dbLoading));
        await databaseHandlerAdmin.addCurrenciesAdmin(currencies: event.currencies);
        emit(state.copyWith(states: DatabaseStatesAdmin.currenciesAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.currenciesNotAdded));
        rethrow;
      }
    });
    // delet Currencies
    on<DatabaseEventDeleteCurrenciesAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteCurrencies fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.deleteCurrenciesAdmin(currencies: event.currencies);
        emit(state.copyWith(states: DatabaseStatesAdmin.currenciesDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.currenciesNotDeleted));
        rethrow;
      }
    });

    //Featured Products ---------------------------------------------------------------------------------------------------------------
    //fetch all featured products


    //add featured product
    on<DatabaseEventAddFeaturedProductAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventAddFeaturedProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin.dbLoading));
        await databaseHandlerAdmin.addFeaturedProductAdmin(productId: event.product.id);
        emit(state.copyWith(states: DatabaseStatesAdmin.featuedProductsAdded));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.featuedProductsNotAdded));
        rethrow;
      }
    });

    on<DatabaseEventDeleteFeaturedProductAdmin>((event, emit) async {
      print('---');
      print('--- DatabaseEventDeleteFeaturedProduct fired');
      print('---');
      try {
        emit(state.copyWith(states: DatabaseStatesAdmin .dbLoading));
        await databaseHandlerAdmin.deleteFeaturedProductAdmin(
          productId: event.product.id,
        );
        emit(state.copyWith(states: DatabaseStatesAdmin .featuedProductsDeleted));
      } catch (e) {
        emit(state.copyWith(states: DatabaseStatesAdmin.featuedProductsNotDeleted));
        rethrow;
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
