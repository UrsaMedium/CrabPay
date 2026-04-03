import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_event.dart';
import 'package:crabpay/home_view/bloc/home_pages_navigation_bloc/home_pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePagesBloc extends Bloc<HomePagesEvent, HomePagesState> {
  HomePagesBloc() : super(HomePagesStateHomePage()) {
    // when page is selcted on the bottom bar navigator
    on<HomePagesEventOnPageChange>((event, emit) {
      if (event.index == 0) {
        emit(const HomePagesStateHomePage());
      } else if (event.index == 1) {
        emit(const HomePagesStateStorePage());
      } else if (event.index == 2) {
        emit(const HomePagesStateWalletPage());
      }
    });
  }
}
