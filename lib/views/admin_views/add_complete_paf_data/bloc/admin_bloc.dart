import 'package:bloc/bloc.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_event.dart';
import 'package:crabpay/views/admin_views/add_complete_paf_data/bloc/admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(const AdminStateNoAdmin()) {
    on<AdminEventAdminEnters>((event, emit) {});

    on<AdminEventAdminSubmitsProduct>((event, emit) {
      emit(AdminStateSubmitedProduct(appProduct: event.appProduct));
    });

    on<AdminEventAdminSubmitsFields>((event, emit) {
      emit(AdminStateSubmitedFields(appProductFields: event.appProductFields));
    });

    on<AdminEventAdminSubmitsPriceSpace>((event, emit) {
      emit(
        AdminStateSubmitedDimentions(priceSpace: event.priceSpace),
      );
    });
    
  }
}
