import 'package:crabpay/home_view/bloc/home_pages_bloc/home_pages_event.dart';
import 'package:crabpay/home_view/bloc/home_pages_bloc/home_pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePagesBloc extends Bloc<HomePagesEvent, HomePagesState> {
  HomePagesBloc() : super(HomePagesStateHomePage()) {
    // home page is selected
    on<HomePagesEventHomeSelected>(
      (event, emit) => emit(const HomePagesStateHomePage()),
    );

    // store page is selected
    on<HomePagesEventStoreSelected>(
      (event, emit) => emit(const HomePagesStateStorePage()),
    );

    // wallet page is selected
    on<HomePagesEventWalletSelected>(
      (event, emit) => emit(const HomePagesStateWalletPage()),
    );
  }
}
