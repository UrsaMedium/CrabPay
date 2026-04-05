import 'package:crabpay/views/home_view/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_event.dart';
import 'package:crabpay/views/home_view/bloc/page_view_and_navigation_bar_sync_bloc/home_pages_state.dart';
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
