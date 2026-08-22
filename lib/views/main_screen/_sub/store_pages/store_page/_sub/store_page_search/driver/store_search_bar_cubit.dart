import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class StoreSearchBarState extends Equatable {
  final bool isSearchOpen;
  final bool keyBoardEventCanBeTriggered;
  final List<Product>? products;

  const StoreSearchBarState({
    this.isSearchOpen = false,
    this.products,
    this.keyBoardEventCanBeTriggered = false,
  });

  StoreSearchBarState copyWith({
    bool? isSearchOpen,
    List<Product>? products,
    bool? keyBoardEventCanBeTriggered,
  }) => StoreSearchBarState(
    isSearchOpen: isSearchOpen ?? this.isSearchOpen,
    products: products ?? this.products,
    keyBoardEventCanBeTriggered:
        keyBoardEventCanBeTriggered ?? this.keyBoardEventCanBeTriggered,
  );

  @override
  List<Object?> get props => [
    isSearchOpen,
    products,
    keyBoardEventCanBeTriggered,
  ];
}

class StoreSearchBarCubit extends Cubit<StoreSearchBarState> {
  StoreSearchBarCubit() : super(const StoreSearchBarState());
}
