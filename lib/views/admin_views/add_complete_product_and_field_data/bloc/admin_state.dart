import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s4_price_space_filling/data_and_widgets_preperation.dart';
import 'package:flutter/foundation.dart' show immutable;

enum AdminStates {
  initial,
  adminSubmitedAppProduct,
  adminSubmitedAppProductFields,
  adminSubmitedPriceDimensions,
  adminSubmitedPriceFunctions,
  dataForSpaceFillingIsReady
}

@immutable
class AdminState {
  final Product? appProduct;
  final List<ProductField>? appProductFields;
  final Map<ProductField, String>? priceDimensions;
  final Map<List<String>, double>? priceFunction;
  final DataAndWidgetsPreperation? dataAndWidgetsPreperation;
  final AdminStates states;

  const AdminState({
    this.priceDimensions,
    this.appProduct,
    this.appProductFields,
    this.priceFunction,
    this.dataAndWidgetsPreperation,
    this.states = AdminStates.initial,
  });

  AdminState copyWith({
    Product? appProduct,
    List<ProductField>? appProductFields,
    Map<ProductField, String>? priceDimensions,
    Map<List<String>, double>? priceFunction,
    DataAndWidgetsPreperation? dataAndWidgetsPreperation,
    AdminStates? states,
  }) {
    return AdminState(
      appProduct: appProduct ?? this.appProduct,
      appProductFields: appProductFields ?? this.appProductFields,
      priceDimensions: priceDimensions ?? this.priceDimensions,
      priceFunction: priceFunction ?? this.priceFunction,
      dataAndWidgetsPreperation:
          dataAndWidgetsPreperation ?? this.dataAndWidgetsPreperation,
      states: states ?? this.states,
    );
  }
}
