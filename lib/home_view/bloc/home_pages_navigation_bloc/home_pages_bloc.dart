import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_event.dart';
import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePagesBloc extends Bloc<HomePagesEvent, HomePagesState> {
  HomePagesBloc() : super(HomePagesStatePageTabPosition(index: 0)) {
    on<HomePagesEventOnPageChange>((event, emit) {
      emit (HomePagesStatePageTabPosition(index: event.index));
    });
  }
}
