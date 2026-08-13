import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProductViewLayers { groundLayer, descriptionLayer, buyLayer }

class ProductViewState {
  final bool isAdmin;
  final bool isAnonymous;
  final bool isFavorite;
  final String? userId;
  final Product? product;
  final List<ProductField>? productFields;
  final bool isLoading;
  final bool isFavoriteLoading;
  final ProductViewLayers layer;

  ProductViewState({
    this.isAdmin = false,
    this.isAnonymous = false,
    this.userId,
    this.product,
    this.productFields,
    this.isLoading = true,
    this.layer = ProductViewLayers.groundLayer,
    this.isFavorite = false,
    this.isFavoriteLoading = true,
  });

  ProductViewState copyWith({
    bool? isAdmin,
    bool? isAnonymous,
    String? userId,
    Product? product,
    List<ProductField>? productFields,
    bool? isLoading,
    ProductViewLayers? layer,
    bool? isFavorite,
    bool? isFavoriteLoading,
  }) {
    return ProductViewState(
      isAdmin: isAdmin ?? this.isAdmin,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      layer: layer ?? this.layer,
      product: product ?? this.product,
      productFields: productFields ?? this.productFields,
      isFavorite: isFavorite ?? this.isFavorite,
      isFavoriteLoading: isFavoriteLoading ?? this.isFavoriteLoading,
    );
  }
}

class ProductViewCubit extends Cubit<ProductViewState> {
  final DatabaseBloc _databaseBloc;
  late final StreamSubscription _databaseSubscription;
  ProductViewCubit({
    required DatabaseBloc databaseBloc,
    required bool isAdmin,
    required bool isAnonymous,
    required String userId,
    required Product product,
    required List<ProductField> productFields,
  }) : _databaseBloc = databaseBloc,
       super(ProductViewState()) {
    emit(
      state.copyWith(
        isAdmin: isAdmin,
        isAnonymous: isAnonymous,
        userId: userId,
        product: product,
        productFields: productFields,
      ),
    );
    _databaseSubscription = _databaseBloc.stream.listen((databaseState) {
      _syncDabaseData(databaseState);
    });
  }

  void _syncDabaseData(DatabaseState databaseState) {
    emit(
      state.copyWith(
        isLoading: false,
        isFavoriteLoading: false,
        isFavorite:
            databaseState.userPreferences?.any(
              ((element) => element.id == state.product?.id),
            ) ??
            false,
      ),
    );
  }

  void setLayer(bool isUp) {
    switch (state.layer) {
      case ProductViewLayers.groundLayer:
        if (isUp) {
          emit(state.copyWith(layer: ProductViewLayers.descriptionLayer));
        }
        break;
      case ProductViewLayers.descriptionLayer:
        if (isUp) {
          emit(state.copyWith(layer: ProductViewLayers.buyLayer));
        } else {
          emit(state.copyWith(layer: ProductViewLayers.groundLayer));
        }
        break;
      case ProductViewLayers.buyLayer:
        if (!isUp) {
          emit(state.copyWith(layer: ProductViewLayers.descriptionLayer));
        }
        break;
    }
  }

  void setFavoriteLoadingStateTrue() {
    emit(state.copyWith(isFavoriteLoading: true));
  }

  void setLoadingStateTrue() {}

  @override
  Future<void> close() {
    _databaseSubscription.cancel();
    return super.close();
  }
}
