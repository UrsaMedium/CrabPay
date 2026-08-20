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
  final double containerHalfWidth;
  final bool isInitialized;

  const HomePageState({
    this.featuredProducts,
    this.userPreferences,
    this.isLoading = true,
    this.containerHalfWidth = 300,
    this.isInitialized = false,
  });

  HomePageState copyWith({
    List<Product>? featuredProducts,
    List<Product>? userPreferences,
    double? containerHalfWidth,
    bool? isLoading,
    bool? isInitialized,
  }) => HomePageState(
    featuredProducts: featuredProducts ?? this.featuredProducts,
    userPreferences: userPreferences ?? this.userPreferences,
    containerHalfWidth: containerHalfWidth ?? this.containerHalfWidth,
    isLoading: isLoading ?? this.isLoading,
    isInitialized: isInitialized ?? this.isInitialized,
  );

  @override
  List<Object?> get props => [
    featuredProducts,
    userPreferences,
    isLoading,
    isInitialized,
    containerHalfWidth,
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

  void setLayouts({required double containerHalfWidth}) {
    emit(state.copyWith(containerHalfWidth: containerHalfWidth));
  }

  @override
  Future<void> close() {
    _dbSubscription.cancel();
    return super.close();
  }
}
