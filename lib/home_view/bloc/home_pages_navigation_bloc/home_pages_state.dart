import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomePagesState {
  final int index;
  const HomePagesState({required this.index,});
}

class HomePagesStatePageTabPosition extends HomePagesState {
  const HomePagesStatePageTabPosition({required super.index});
}