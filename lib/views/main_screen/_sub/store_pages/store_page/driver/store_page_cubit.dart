import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class StorePageState extends Equatable {
  final bool isHeroFlies;
  final String? whoFlies;
  final List<Product>? filterdProductList;
  final List<Product>? products;
  final List<Product>? productsToShow;
  final double outerCornerRadius;
  final double containerWidth;
  final double containerPadding;

  const StorePageState({
    this.filterdProductList,
    this.products,
    this.productsToShow,
    this.isHeroFlies = false,
    this.whoFlies,
    this.outerCornerRadius = 16,
    this.containerWidth = 600,
    this.containerPadding = 8,
  });

  StorePageState copyWith({
    List<Product>? filterdProductList,
    List<Product>? products,
    List<Product>? productsToShow,
    bool? isHeroFlies,
    String? whoFlies,
    double? outerCornerRadius,
    double? containerWidth,
    double? containerPadding,
  }) {
    return StorePageState(
      filterdProductList: filterdProductList ?? this.filterdProductList,
      products: products ?? this.products,
      productsToShow: productsToShow ?? this.productsToShow,
      isHeroFlies: isHeroFlies ?? this.isHeroFlies,
      whoFlies: whoFlies == null
          ? this.whoFlies
          : whoFlies.isEmpty
          ? null
          : whoFlies,
      containerWidth: containerWidth ?? this.containerWidth,
      outerCornerRadius: outerCornerRadius ?? this.outerCornerRadius,
      containerPadding: containerPadding ?? this.containerPadding,
    );
  }

  @override
  List<Object?> get props => [
    filterdProductList,
    products,
    productsToShow,
    isHeroFlies,
    whoFlies,
    outerCornerRadius,
    containerWidth,
    containerPadding,
  ];
}

class StorePageCubit extends Cubit<StorePageState> {
  final DatabaseBloc _dbBloc;
  late final StreamSubscription _dbSubscription;
  StorePageCubit({required DatabaseBloc dbBLoc}) : _dbBloc = dbBLoc, super(StorePageState()) {
    final prdtcs = dbBLoc.state.products;
    emit(state.copyWith(products: prdtcs, productsToShow: prdtcs));
    _dbSubscription = _dbBloc.stream.listen((dbState) {
      if (dbState.states == DatabaseStates.productsFetched) {
        emit(
          state.copyWith(
            products: dbState.products,
            productsToShow: (state.filterdProductList?.isEmpty ?? true) ? dbState.products : state.filterdProductList,
          ),
        );
      }
    });
  }

  void setFilteredList(List<Product> filteredList) {
    if (filteredList.isEmpty) {
      emit(state.copyWith(productsToShow: state.products));
    } else {
      emit(state.copyWith(productsToShow: filteredList));
    }
  }

  void setHeroFlightTrue(String whoFlies) {
    emit(state.copyWith(isHeroFlies: true, whoFlies: whoFlies));
  }

  void setHeroFlightFalse() {
    emit(state.copyWith(isHeroFlies: false, whoFlies: ''));
  }

  void setLayouts({required double containerWidth}) {
    double width = containerWidth < 600 ? containerWidth : 600;
    emit(
      state.copyWith(
        containerWidth: width,
        outerCornerRadius: width * .05,
        containerPadding: width * .02,
      ),
    );
  }

  @override
  Future<void> close() {
    _dbSubscription.cancel();
    return super.close();
  }
}
