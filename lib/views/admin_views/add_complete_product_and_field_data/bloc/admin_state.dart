import 'package:crabpay/core/backend/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/views/admin_views/add_complete_product_and_field_data/s3_price_space_filling/data_and_widgets_preperation.dart';
import 'package:flutter/foundation.dart' show immutable;

enum AdminStates {
  initial,
  adminSubmitedAppProduct,
  adminSubmitedAppProductFields,
  adminSubmitedPriceImage,
  dataForSpaceFillingIsReady,
}

@immutable
class AdminState {
  final Product? appProduct;
  final List<ProductField>? appProductFields;
  final String? currency;
  final DataAndWidgetsPreperation? dataAndWidgetsPreperation;
  final AdminStates states;

  const AdminState({
    this.currency,
    this.appProduct,
    this.appProductFields,
    this.dataAndWidgetsPreperation,
    this.states = AdminStates.initial,
  });

  AdminState copyWith({
    Product? appProduct,
    List<ProductField>? appProductFields,
    String? currency,
    DataAndWidgetsPreperation? dataAndWidgetsPreperation,
    AdminStates? states,
  }) {
    return AdminState(
      appProduct: appProduct ?? this.appProduct,
      appProductFields: appProductFields ?? this.appProductFields,
      currency: currency ?? this.currency,
      dataAndWidgetsPreperation:
          dataAndWidgetsPreperation ?? this.dataAndWidgetsPreperation,
      states: states ?? this.states,
    );
  }
}
