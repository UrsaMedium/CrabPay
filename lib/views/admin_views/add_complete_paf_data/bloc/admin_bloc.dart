import 'package:bloc/bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_state.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/s4_price_space_filling/data_and_widgets_preperation.dart';

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
  }
}
