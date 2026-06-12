import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_bloc_event.dart';
import 'package:crabpay/core/backend_and_bindings/database/subscribtion_data/product_cart/cart_bloc_state.dart';

class CartBloc extends Bloc<CartBlocEvent, CartBlocState> {
  CartBloc() : super(EmptyCartBlocState()) ;
}