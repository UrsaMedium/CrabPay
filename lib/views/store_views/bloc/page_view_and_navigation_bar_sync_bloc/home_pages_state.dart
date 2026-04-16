import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomeViewState {
  final int? pageIndex;
  const HomeViewState({this.pageIndex,});
}

class HomeViewBottomNavBarState extends HomeViewState {
  const HomeViewBottomNavBarState({super.pageIndex});
}

class HomeViewOnProfileTapState extends HomeViewState {
  const HomeViewOnProfileTapState();
}