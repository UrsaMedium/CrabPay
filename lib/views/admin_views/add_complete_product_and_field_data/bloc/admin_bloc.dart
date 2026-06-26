import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/static_data/db_inner_circle/database_bloc/database_event.dart';
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
        event.context.read<DatabaseBloc>().add(
          DatabaseEventAddProduct(product: productToPush),
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
          event.context.read<DatabaseBloc>().add(
            DatabaseEventAddProductField(productField: fieldToPush),
          );
        }
        event.context.go('/');
      } catch (e) {
        Fluttertoast.showToast(msg: 'BOO');
      }
    });
  }
}
