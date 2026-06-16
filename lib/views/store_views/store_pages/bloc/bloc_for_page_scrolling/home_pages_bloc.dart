
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_event.dart';
import 'package:crabpay/views/store_views/store_pages/bloc/bloc_for_page_scrolling/home_pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc() : super(HomeViewBottomNavBarState(pageIndex: 0)) {
    on<HomeViewOnPageSwipeEvent>(
      (event, emit) => emit(HomeViewBottomNavBarState(pageIndex: event.pageIndex)),
    );
    on<HomeViewOnProfileTapEvent>(
      (event, emit) => emit(HomeViewOnProfileTapState()),
    );
  }
}