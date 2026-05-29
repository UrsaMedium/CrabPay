import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/inner_paf_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/paf_bloc/paf_event.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/paf_bloc/paf_state.dart';

class PafBloc extends Bloc<PafEvent, PafState> {
  PafBloc(InnerProductAndFieldsHandler papHandler)
    : super(const PafStateDataNotFetched()) {
    on<PafEventFetchAllPAPData>((event, emit) async {
      // showLoading(event.context);
      try {
        await papHandler.fetchAllPAFData();
        emit(PafStateDataFetched());
      } catch (e) {
        emit(PafStateDataNotFetched());
      }
    });

    on<PafEventAddProductField>((event, emit) async {
      try {
        await papHandler.addProductField(event.productField);
      } catch (_) {
        rethrow;
      }
    });

    on<PafEventDeleteProductField>((event, emit) async {
      try {
        await papHandler.deleteProductField(event.productField);
      } catch (_) {
        rethrow;
      }
    });
  }
}
