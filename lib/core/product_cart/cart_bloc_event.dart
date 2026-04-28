
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CartBlocEvent {
  const CartBlocEvent();
}

class AddItemCartBlocEvent {
  const AddItemCartBlocEvent();
}

class DeleteItemCartBlocEvent {
  const DeleteItemCartBlocEvent();
} 

class DeleteAllItemsCartBlocEvent {
  const DeleteAllItemsCartBlocEvent();
} 