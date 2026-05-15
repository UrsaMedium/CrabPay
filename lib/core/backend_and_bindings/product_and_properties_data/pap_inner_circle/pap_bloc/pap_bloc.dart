import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/inner_pap_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/pap_bloc/pap_event.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/pap_bloc/pap_state.dart';

class PapBloc extends Bloc<PapEvent, PapState> {
  PapBloc(InnerProductAndPropertiesHandler papHandler)
    : super(const PapStateDataNotFetched()) {
    on<PapEventFetchAllPAPData>((event, emit) async {
      // showLoading(event.context);
      try {
        await papHandler.fetchAllPAPData();
        emit(PapStateDataFetched());
      } catch (e) {
        emit(PapStateDataNotFetched());
      }
    });

    on<PapEventAddProductProperty>((event, emit) async {
      try {
        await papHandler.addProductProperty(event.productProperty);
      } catch (_) {
        rethrow;
      }
    });

    on<PapEventDeleteProductProperty>((event, emit) async {
      try {
        await papHandler.deleteProductProperty(event.productProperty);
      } catch (_) {
        rethrow;
      }
    });
  }
}
