import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomePagesState {
  final int index;
  const HomePagesState({required this.index});
}

class HomePagesStateHomePage extends HomePagesState {
  const HomePagesStateHomePage() : super(index: 0);
}

class HomePagesStateStorePage extends HomePagesState {
  const HomePagesStateStorePage() : super(index: 1);
}

class HomePagesStateWalletPage extends HomePagesState {
  const HomePagesStateWalletPage() : super(index: 2);
}
