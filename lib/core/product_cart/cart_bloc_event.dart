
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CartBlocEvent {
  const CartBlocEvent();
}

class ItemAddCartBlocEvent {
  const ItemAddCartBlocEvent();
} 