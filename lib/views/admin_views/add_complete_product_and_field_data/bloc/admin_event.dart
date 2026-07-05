import 'package:crabpay/core/backend/database/static_data/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend/database/static_data/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AdminEvent {
  const AdminEvent();
}

class AdminEventAdminEnters extends AdminEvent {
  const AdminEventAdminEnters();
}

class AdminEventSubmitsProduct extends AdminEvent {
  final Product appProduct;
  const AdminEventSubmitsProduct({required this.appProduct});
}

class AdminEventSubmitsFields extends AdminEvent {
  final List<ProductField> appProductFields;
  const AdminEventSubmitsFields({required this.appProductFields});
}

class AdminEventEntersPriceImageFilling extends AdminEvent {
  final BuildContext context;
  const AdminEventEntersPriceImageFilling({required this.context});
}

class AdminEventPriceFillingDataIsPrepared extends AdminEvent {
  const AdminEventPriceFillingDataIsPrepared();
}

class AdminEventSubmitsPriceImage extends AdminEvent {
  final Map<String, double> priceImage;
  final ProductField imageField;
  final List<ProductField> fieldsList;
  const AdminEventSubmitsPriceImage({
    required this.priceImage,
    required this.imageField,
    required this.fieldsList,
  });
}

class AdminEventPushesData extends AdminEvent {
  final BuildContext context;
  const AdminEventPushesData({required this.context});
}
