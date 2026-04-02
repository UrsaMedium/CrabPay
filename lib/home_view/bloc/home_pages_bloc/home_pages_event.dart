import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomePagesEvent {
  const HomePagesEvent();
}

class HomePagesEventHomeSelected extends HomePagesEvent {
  const HomePagesEventHomeSelected();
}

class HomePagesEventStoreSelected extends HomePagesEvent {
  const HomePagesEventStoreSelected();
}

class HomePagesEventWalletSelected extends HomePagesEvent {
  const HomePagesEventWalletSelected();
}
