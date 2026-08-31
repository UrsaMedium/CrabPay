import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class HomePageState extends Equatable {
  final List<Product>? featuredProducts;
  final List<Product>? userPreferences;
  final bool isLoading;
  final double outerCornerRadius;
  final double containerWidth;
  final double containerPadding;
  final bool isInitialized;

  const HomePageState({
    this.featuredProducts,
    this.userPreferences,
    this.isLoading = true,
    this.isInitialized = false,
    this.outerCornerRadius = 624,
    this.containerWidth = 24,
    this.containerPadding = 8,
  });

  HomePageState copyWith({
    List<Product>? featuredProducts,
    List<Product>? userPreferences,
    double? outerCornerRadius,
    double? containerWidth,
    bool? isLoading,
    bool? isInitialized,
    double? containerPadding,
  }) => HomePageState(
    featuredProducts: featuredProducts ?? this.featuredProducts,
    userPreferences: userPreferences ?? this.userPreferences,
    isLoading: isLoading ?? this.isLoading,
    isInitialized: isInitialized ?? this.isInitialized,
    containerWidth: containerWidth ?? this.containerWidth,
    outerCornerRadius: outerCornerRadius ?? this.outerCornerRadius,
    containerPadding: containerPadding ?? this.containerPadding,
  );

  @override
  List<Object?> get props => [
    featuredProducts,
    userPreferences,
    isLoading,
    isInitialized,
    outerCornerRadius,
    containerWidth,
    containerPadding,
  ];
}

class HomePageCubit extends Cubit<HomePageState> {
  final DatabaseBloc _dbBloc;
  late final StreamSubscription _dbSubscription;
  HomePageCubit({required DatabaseBloc dbBloc})
    : _dbBloc = dbBloc,
      super(const HomePageState()) {
    _dbSubscription = _dbBloc.stream.listen((dbState) {
      _syncDabaseData(dbState);
    });
  }

  void _syncDabaseData(DatabaseState dbState) {
    if (dbState.states == DatabaseStates.initialized) {
      emit(state.copyWith(isInitialized: true));
    }
    emit(state.copyWith(featuredProducts: _dbBloc.state.featuredProducts));
    emit(state.copyWith(userPreferences: _dbBloc.state.userPreferences));
  }

  void setLayouts({required double containerWidth}) {
    emit(
      state.copyWith(
        containerWidth: containerWidth,
        outerCornerRadius: containerWidth * .05,
        containerPadding: containerWidth * .02,
      ),
    );
  }

  @override
  Future<void> close() {
    _dbSubscription.cancel();
    return super.close();
  }
}
