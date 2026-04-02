import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class HomePagesState {
  const HomePagesState();
 // implement view emition 
}

class HomePagesStateHomePage extends HomePagesState {
  const HomePagesStateHomePage();
}

class HomePagesStateStorePage extends HomePagesState {
  const HomePagesStateStorePage();
}

class HomePagesStateWalletPage extends HomePagesState {
  const HomePagesStateWalletPage();
}