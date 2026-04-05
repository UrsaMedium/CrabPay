import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomeViewEvent {
  const HomeViewEvent();
}

class HomeViewOnPageSwipeEvent extends HomeViewEvent {
  final int pageIndex;
  const HomeViewOnPageSwipeEvent({required this.pageIndex});
}

class HomeViewOnProfileTapEvent extends HomeViewEvent {
  const HomeViewOnProfileTapEvent();
}