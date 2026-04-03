import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomePagesEvent {
  const HomePagesEvent();
}

class HomePagesEventOnPageChange extends HomePagesEvent {
  final int index;
  const HomePagesEventOnPageChange({required this.index});
}

class HomePagesEventOnEvent extends HomePagesEvent {
  const HomePagesEventOnEvent();
}