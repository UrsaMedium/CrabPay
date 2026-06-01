import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/database_bloc/database_event.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_state.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s4_price_space_filling/data_and_widgets_preperation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(const AdminState()) {
    on<AdminEventAdminEnters>((event, emit) {});

    on<AdminEventSubmitsProduct>((event, emit) {
      emit(
        state.copyWith(
          appProduct: event.appProduct,
          states: AdminStates.adminSubmitedAppProduct,
        ),
      );
    });

    on<AdminEventSubmitsFields>((event, emit) {
      emit(
        state.copyWith(
          appProductFields: event.appProductFields,
          states: AdminStates.adminSubmitedAppProductFields,
        ),
      );
    });

    on<AdminEventSubmitsPriceDimensions>((event, emit) {
      emit(
        state.copyWith(
          priceDimensions: event.priceDimensions,
          functionType: event.functionType,
          currency: event.currency,
          states: AdminStates.adminSubmitedPriceDimensions,
        ),
      );
    });

    on<AdminEventEntersSpaceFillingView>((event, emit) {
      DataAndWidgetsPreperation dataAndWidgetsPreperation =
          DataAndWidgetsPreperation(context: event.context);
      emit(
        state.copyWith(dataAndWidgetsPreperation: dataAndWidgetsPreperation),
      );
    });

    on<AdminEventSpaceFillingDataIsPrepared>(
      (event, emit) =>
          emit(state.copyWith(states: AdminStates.dataForSpaceFillingIsReady)),
    );

    on<AdminEventSubmitsPriceFunction>((event, emit) {
      emit(
        state.copyWith(
          priceFunction: event.priceFunction,
          states: AdminStates.adminSubmitedPriceFunctions,
        ),
      );
    });

    on<AdminEventPushesData>((event, emit) {
      var uuid = Uuid();
      String theProductId = uuid.v4();
      Product productToPush = Product(
        id: theProductId,
        name: state.appProduct!.name,
        image: state.appProduct!.image,
        description: state.appProduct!.description,
      );
      event.context.read<DatabaseBloc>().add(
        DatabaseEventAddProduct(product: productToPush),
      );

      for (var field in state.appProductFields!) {
        final fieldToPush = ProductField(
          id: '',
          productId: theProductId,
          order: field.order,
          fieldName: field.fieldName,
          handler: field.handler,
          attributes: field.attributes,
          expectedData: field.expectedData,
        );
        event.context.read<DatabaseBloc>().add(
          DatabaseEventAddProductField(productField: fieldToPush),
        );
      }

      PriceFunction function = PriceFunction(
        id: '',
        name: '',
        type: state.functionType!,
        currency: state.currency!,
        productId: theProductId,
        fomulas: state.priceFunction!,
      );
      event.context.read<DatabaseBloc>().add(
        DatabaseEventAddPriceFunction(priceFunction: function),
      );
      Fluttertoast.showToast(msg: 'BOO');
    });
  }
}
