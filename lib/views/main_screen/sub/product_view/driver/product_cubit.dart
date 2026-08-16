import 'dart:async';

import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_bloc.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/database_bloc/database_state.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/cart_bloc/cart_bloc_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ProductViewLayers { groundLayer, descriptionLayer, buyLayer }

class ProductViewState extends Equatable {
  final bool isAdmin;
  final bool isAnonymous;
  final bool isFavorite;
  final String? userId;
  final Product? product;
  final bool isLoading;
  final bool isFavoriteLoading;
  final bool isCartLoading;
  final ProductViewLayers layer;
  final Map<ProductViewLayers, double>? descriptionLayerPositions;
  final Map<ProductViewLayers, double>? buyLayerPositions;
  final Map<String, double>? layoutBoundries;
  final GlobalKey descriptionLayerKey;
  final double? descHeight;
  final double descPosition;
  final double descMinPosition;
  final Color? tintColor;
  //for buy layer
  final List<ProductField>? productFields;
  final ProductField? imageField;
  final Map<String, double>? priceFunction;
  final bool? isLinearFunction;
  final int? amountOfRequiredFields;
  final bool isEveryFieldSatisfied;
  final Map<String, String>? retrievedData;
  final double precalculatedPrice;
  final int itemsInCart;
  final GlobalKey buyLayerKey;
  final double? buyLayerHeight;
  final double buyPosition;

  const ProductViewState({
    this.isAdmin = false,
    this.isAnonymous = false,
    this.userId,
    this.product,
    this.productFields,
    this.imageField,
    this.isLoading = true,
    this.layer = ProductViewLayers.groundLayer,
    this.isFavorite = false,
    this.isFavoriteLoading = true,
    this.isEveryFieldSatisfied = false,
    this.retrievedData,
    this.precalculatedPrice = 0,
    this.amountOfRequiredFields,
    this.priceFunction,
    this.isLinearFunction,
    this.itemsInCart = 0,
    this.isCartLoading = false,
    required this.buyLayerKey,
    this.buyLayerHeight,
    this.descriptionLayerPositions,
    this.layoutBoundries,
    this.buyLayerPositions,
    required this.descriptionLayerKey,
    this.descHeight,
    this.descPosition = 1000,
    this.buyPosition = 1000,
    this.descMinPosition = 1000,
    this.tintColor,
  });

  ProductViewState copyWith({
    bool? isAdmin,
    bool? isAnonymous,
    String? userId,
    Product? product,
    bool? isLoading,
    ProductViewLayers? layer,
    bool? isFavorite,
    bool? isFavoriteLoading,
    Map<ProductViewLayers, double>? descriptionLayerPositions,
    Map<ProductViewLayers, double>? buyLayerPositions,
    Map<String, double>? layoutBoundries,
    GlobalKey? descriptionLayerKey,
    double? descHeight,
    double? descPosition,
    double? descMinPosition,
    Color? tintColor,
    //buy
    List<ProductField>? productFields,
    ProductField? imageField,
    int? amountOfRequiredFields,
    Map<String, double>? priceFunction,
    bool? isLinearFunction,
    bool? isEveryFieldSatisfied,
    Map<String, String>? retrievedData,
    double? precalculatedPrice,
    int? itemsInCart,
    bool? isCartLoading,
    GlobalKey? buyLayerKey,
    double? buyLayerHeight,
    double? buyPosition,
  }) {
    return ProductViewState(
      isAdmin: isAdmin ?? this.isAdmin,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      layer: layer ?? this.layer,
      product: product ?? this.product,
      isFavorite: isFavorite ?? this.isFavorite,
      isFavoriteLoading: isFavoriteLoading ?? this.isFavoriteLoading,
      descriptionLayerKey: descriptionLayerKey ?? this.descriptionLayerKey,
      descHeight: descHeight,
      descPosition: descPosition ?? this.descPosition,
      descMinPosition: descMinPosition ?? this.descMinPosition,
      tintColor: tintColor ?? this.tintColor,
      //buy
      productFields: productFields ?? this.productFields,
      imageField: imageField ?? this.imageField,
      priceFunction: priceFunction ?? this.priceFunction,
      isLinearFunction: isLinearFunction ?? this.isLinearFunction,
      amountOfRequiredFields:
          amountOfRequiredFields ?? this.amountOfRequiredFields,
      isEveryFieldSatisfied:
          isEveryFieldSatisfied ?? this.isEveryFieldSatisfied,
      precalculatedPrice: precalculatedPrice ?? this.precalculatedPrice,
      retrievedData: retrievedData ?? this.retrievedData,
      itemsInCart: itemsInCart ?? this.itemsInCart,
      isCartLoading: isCartLoading ?? this.isCartLoading,
      buyLayerKey: buyLayerKey ?? this.buyLayerKey,
      buyLayerHeight: buyLayerHeight ?? this.buyLayerHeight,
      descriptionLayerPositions:
          descriptionLayerPositions ?? this.descriptionLayerPositions,
      buyLayerPositions: buyLayerPositions ?? this.buyLayerPositions,
      layoutBoundries: layoutBoundries ?? this.layoutBoundries,
      buyPosition: buyPosition ?? this.buyPosition,
    );
  }

  @override
  List<Object?> get props => [
    isAdmin,
    isAnonymous,
    userId,
    product,
    isLoading,
    layer,
    isFavorite,
    isFavoriteLoading,
    descriptionLayerPositions,
    layoutBoundries,
    descriptionLayerKey,
    descHeight,
    descPosition,
    descMinPosition,
    //buy
    productFields,
    imageField,
    amountOfRequiredFields,
    priceFunction,
    isLinearFunction,
    isEveryFieldSatisfied,
    retrievedData,
    precalculatedPrice,
    itemsInCart,
    isCartLoading,
    buyLayerKey,
    buyLayerHeight,
    descriptionLayerPositions,
    buyLayerPositions,
    layoutBoundries,
    buyPosition,
  ];

  // List<Object>
}

class ProductViewCubit extends Cubit<ProductViewState> {
  final DatabaseBloc _databaseBloc;
  final CartBloc _cartBloc;
  late final StreamSubscription _databaseSubscription;
  late final StreamSubscription _cartSubscription;
  ProductViewCubit({
    required DatabaseBloc databaseBloc,
    required CartBloc cartBloc,
    required bool isAdmin,
    required bool isAnonymous,
    required String userId,
    required Product product,
    required List<ProductField>? productFields,
    required Color? tintColor,
    // required Map<String, double> layoutBoundries,
  }) : _databaseBloc = databaseBloc,
       _cartBloc = cartBloc,
       super(
         ProductViewState(
           buyLayerKey: GlobalKey(),
           descriptionLayerKey: GlobalKey(),
         ),
       ) {
    //
    //
    ProductField? imageField;
    if (productFields != null) {
      imageField = productFields.firstWhere((element) => element.isPriceImage);
    }

    emit(
      state.copyWith(
        isAdmin: isAdmin,
        isAnonymous: isAnonymous,
        userId: userId,
        product: product,
        productFields: productFields,
        imageField: imageField,
        amountOfRequiredFields: productFields?.length,
        priceFunction: imageField?.priceImages,
        isLinearFunction: imageField?.handler == 'InputField',
        isFavoriteLoading: false,
        isLoading: false,
        isFavorite:
            databaseBloc.state.userPreferences?.any(
              ((element) => element.id == product.id),
            ) ??
            false,
        tintColor: tintColor,
      ),
    );
    _databaseSubscription = _databaseBloc.stream.listen((databaseState) {
      _syncDabaseData(databaseState);
    });
    _cartSubscription = _cartBloc.stream.listen((cartState) {
      _syncCartData(cartState);
    });
  }

  void _syncDabaseData(DatabaseState databaseState) {
    if (databaseState.states == DatabaseStates.userPreferencesAdded ||
        databaseState.states == DatabaseStates.userPreferencesDeleted ||
        databaseState.states == DatabaseStates.userPreferencesFetched ||
        databaseState.states == DatabaseStates.userPreferencesNotAdded ||
        databaseState.states == DatabaseStates.userPreferencesNotDeleted ||
        databaseState.states == DatabaseStates.userPreferencesNotFetched) {
      emit(
        state.copyWith(
          isFavoriteLoading: false,
          isFavorite:
              databaseState.userPreferences?.any(
                ((element) => element.id == state.product?.id),
              ) ??
              false,
        ),
      );
    }
    if (databaseState.states == DatabaseStates.fieldsFetched ||
        databaseState.states == DatabaseStates.fieldsNotFetched) {
      List<ProductField> fields = [
        ...databaseState.cachedProductFields?[state.product!.id] ?? [],
      ];
      final imageField = fields.firstWhere((element) => element.isPriceImage);
      emit(
        state.copyWith(
          imageField: imageField,
          productFields: fields,
          amountOfRequiredFields: fields.length,
          priceFunction: imageField.priceImages,
          isLinearFunction: imageField.handler == 'InputField',
        ),
      );
    }
  }

  void _syncCartData(CartState cartState) {
    if (cartState.states != CartStates.loading) {
      emit(
        state.copyWith(
          itemsInCart: cartState.productCartItemAmount,
          isCartLoading: false,
        ),
      );
    }
    if (cartState.states == CartStates.failedToAdd ||
        cartState.states == CartStates.failedToDeleteLastAddedProductCartItem) {
      Fluttertoast.showToast(msg: 'failed');
      emit(state.copyWith(isCartLoading: false));
    }
  }

  void setLayoutBoundries(Map<String, double> layoutBoundries) {
    final descPosition =
        layoutBoundries['height']! -
        layoutBoundries['paddingBottom']! -
        layoutBoundries['width']!;
    final buyPosition =
        layoutBoundries['height']! - layoutBoundries['paddingBottom']! - 54;

    emit(
      state.copyWith(
        layoutBoundries: layoutBoundries,
        descPosition: descPosition,
        descMinPosition: descPosition,
        buyPosition: buyPosition,
      ),
    );
  }

  void setLayer(bool isUp) {
    final buyContext = state.buyLayerKey.currentContext;
    final descContext = state.descriptionLayerKey.currentContext;

    if (buyContext != null && descContext != null) {
      final buyRenderBox = buyContext.findRenderObject() as RenderBox;
      final descRenderBox = descContext.findRenderObject() as RenderBox;
      final buyLayerHeight = buyRenderBox.size.height;
      final descLayerHeight = descRenderBox.size.height;

      switch (state.layer) {
        case ProductViewLayers.groundLayer:
          if (isUp) {
            final descTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                (descLayerHeight > state.descMinPosition
                    ? descLayerHeight
                    : state.descMinPosition) -
                64;
            emit(
              state.copyWith(
                layer: ProductViewLayers.descriptionLayer,
                descPosition: descTopPosition,
              ),
            );
          }
          break;
        case ProductViewLayers.descriptionLayer:
          if (isUp) {
            final buyTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                buyLayerHeight;
            final descTopPosition = buyTopPosition - 46;
            emit(
              state.copyWith(
                layer: ProductViewLayers.buyLayer,
                descPosition: descTopPosition,
                buyPosition: buyTopPosition,
              ),
            );
          } else {
            final buyTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                54;
            final descTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                state.layoutBoundries!['width']!;
            emit(
              state.copyWith(
                layer: ProductViewLayers.groundLayer,
                descPosition: descTopPosition,
                buyPosition: buyTopPosition,
              ),
            );
          }
          break;
        case ProductViewLayers.buyLayer:
          if (!isUp) {
            final descTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                (descLayerHeight > state.descMinPosition
                    ? descLayerHeight
                    : state.descMinPosition) -
                64;
            final buyTopPosition =
                state.layoutBoundries!['height']! -
                state.layoutBoundries!['paddingBottom']! -
                54;
            emit(
              state.copyWith(
                layer: ProductViewLayers.descriptionLayer,
                descPosition: descTopPosition,
                buyPosition: buyTopPosition,
              ),
            );
          }
          break;
      }
    }
  }

  void setFavoriteLoadingStateTrue() {
    emit(state.copyWith(isFavoriteLoading: true));
  }

  void setcartLoadingStateTrue() {
    emit(state.copyWith(isCartLoading: true));
  }

  void setLoadingStateTrue() {
    emit(state.copyWith(isLoading: true));
  }

  //buy layer ----------------------------------------------------------

  void onUserInput({required String fieldName, required String dataReceived}) {
    Map<String, String> inputMap = state.retrievedData ?? {};
    inputMap[fieldName] = dataReceived;
    double precalculatedPrice = 0;
    if (state.isLinearFunction! && fieldName == state.imageField!.fieldName) {
      precalculatedPrice =
          (double.tryParse(dataReceived) ?? 0) *
          (state.priceFunction?.values.first ?? 0);
    } else {
      precalculatedPrice = state.priceFunction?[dataReceived] ?? 0;
    }

    bool isEveryFieldSatisfied =
        (inputMap.length == state.amountOfRequiredFields);
    if (isEveryFieldSatisfied) {
      for (var field in inputMap.keys) {
        if (inputMap[field]?.isEmpty ?? true) {
          isEveryFieldSatisfied;
          break;
        }
      }
    }
    if (!(state.precalculatedPrice != 0 || precalculatedPrice != 0)) {
      isEveryFieldSatisfied = false;
    }
    emit(
      state.copyWith(
        isEveryFieldSatisfied: isEveryFieldSatisfied,
        precalculatedPrice: precalculatedPrice == 0 ? null : precalculatedPrice,
        retrievedData: inputMap,
      ),
    );
  }

  @override
  Future<void> close() {
    _databaseSubscription.cancel();
    _cartSubscription.cancel();
    return super.close();
  }
}
