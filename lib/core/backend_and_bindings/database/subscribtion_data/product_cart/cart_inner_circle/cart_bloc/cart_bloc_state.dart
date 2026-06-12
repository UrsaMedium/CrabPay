
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CartBlocState {
  const CartBlocState();
}

class EmptyCartBlocState extends CartBlocState {
  const EmptyCartBlocState();
}

class NonEmptyCartBlocState extends CartBlocState{
  const NonEmptyCartBlocState();
}