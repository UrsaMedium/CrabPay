import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_bloc.dart';
import 'package:crabpay/core/backend/admin/admin_database/admin_db_inner_circle/admin_database_bloc/admin_database_event.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/logger/logger_outer_handler/outer_logger_handler.dart';
import 'package:crabpay/main.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/bloc/admin_state.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s3_price_space_filling/data_and_widgets_preperation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
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

    on<AdminEventEntersPriceImageFilling>((event, emit) {
      DataAndWidgetsPreperation dataAndWidgetsPreperation =
          DataAndWidgetsPreperation(context: event.context);
      emit(
        state.copyWith(dataAndWidgetsPreperation: dataAndWidgetsPreperation),
      );
    });

    on<AdminEventPriceFillingDataIsPrepared>(
      (event, emit) =>
          emit(state.copyWith(states: AdminStates.dataForSpaceFillingIsReady)),
    );

    on<AdminEventSubmitsPriceImage>((event, emit) {
      for (var field in event.fieldsList) {
        if (field.isPriceImage) {
          field.giveImageToAttributes = event.priceImage;
        }
      }
      emit(
        state.copyWith(
          appProductFields: event.fieldsList,
          states: AdminStates.adminSubmitedPriceImage,
        ),
      );
    });

    on<AdminEventPushProductEmidiatly>((event, emit) {
      getIt<OuterLoggerHandler>().logBreadcrumb(
        message: 'AdminEventPushProductEmidiatly: pushing product',
        data: {'product': event.appProduct, 'state': state},
      );
      try {
        event.context.read<DatabaseBlocAdmin>().add(
          DatabaseEventAddProductAdmin(product: event.appProduct),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: 'eeeeeh');
        rethrow;
      }
    });

    on<AdminEventPushesData>((event, emit) async {
      var uuid = Uuid();
      String theProductId = uuid.v4();
      Product productToPush = Product(
        id: theProductId,
        name: state.appProduct!.name,
        image: state.appProduct!.image,
        description: state.appProduct!.description,
        currencies: state.appProduct!.currencies,
      );
      try {
        event.context.read<DatabaseBlocAdmin>().add(
          DatabaseEventAddProductAdmin(product: productToPush),
        );

        for (var field in state.appProductFields!) {
          final fieldToPush = ProductField(
            id: '',
            productId: theProductId,
            order: field.order,
            fieldName: field.fieldName,
            isPriceImage: field.isPriceImage,
            handler: field.handler,
            priceImages: field.priceImages,
            expectedData: field.expectedData,
          );
          event.context.read<DatabaseBlocAdmin>().add(
            DatabaseEventAddProductFieldAdmin(productField: fieldToPush),
          );
        }
        getIt<OuterLoggerHandler>().logBreadcrumb(
          message: 'AdminEventPushesData: pushed product and fields',
          data: {'product': productToPush, 'fields': state.appProductFields},
        );
        event.context.go('/');
      } catch (e) {
        getIt<OuterLoggerHandler>().logBreadcrumb(
          message: 'AdminEventPushesData: error pushing product and fields',
          data: {'error': e.toString()},
        );
        Fluttertoast.showToast(msg: 'BOO');
      }
    });
  }
}
