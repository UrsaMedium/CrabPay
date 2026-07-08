import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

class DatabaseEventInitialize implements DatabaseEvent {
  final AuthUser currentUser;
  DatabaseEventInitialize({required this.currentUser});
}

class DatabaseEventFlushData implements DatabaseEvent {}

// Product events
// fetch all Poducts
class DatabaseEventFetchAllProducts implements DatabaseEvent {}

// add Product
class DatabaseEventAddProduct implements DatabaseEvent {
  final Product product;
  DatabaseEventAddProduct({required this.product});
}

// delete Product
class DatabaseEventDeleteProduct implements DatabaseEvent {
  final Product product;
  DatabaseEventDeleteProduct({required this.product});
}

// modify product
class DatabaseEventUpdateProduct implements DatabaseEvent {
  final String productId;
  final String? imageName;
  final String? productName;
  final String? description;
  DatabaseEventUpdateProduct({
    this.imageName,
    this.productName,
    this.description,
    required this.productId,
  });
}

// Fields events
// fetch Product Fields
class DatabaseEventFetchProductFields implements DatabaseEvent {
  final String productId;
  DatabaseEventFetchProductFields({required this.productId});
}

// fetch Product Field
class DatabaseEventFetchProductField implements DatabaseEvent {
  final String productFieldId;
  DatabaseEventFetchProductField({required this.productFieldId});
}

// add Product Field
class DatabaseEventAddProductField implements DatabaseEvent {
  final ProductField productField;
  DatabaseEventAddProductField({required this.productField});
}

// delete Product Field
class DatabaseEventDeleteProductField implements DatabaseEvent {
  final ProductField productField;
  DatabaseEventDeleteProductField({required this.productField});
}

class DatabaseEventUpdateProductFieldUpdateNameAndOrder
    implements DatabaseEvent {
  final ProductField field;
  final int? order;
  final String? fieldName;
  final bool? isPriceImage;

  DatabaseEventUpdateProductFieldUpdateNameAndOrder({
    required this.field,
    this.order,
    this.fieldName,
    required this.isPriceImage,
  });
}

class DatabaseEventUpdateProductFieldSwapImageField implements DatabaseEvent {
  final ProductField oldImageField;
  final ProductField newImageField;
  DatabaseEventUpdateProductFieldSwapImageField({
    required this.oldImageField,
    required this.newImageField,
  });
}

class DatabaseEventUpdateProductFieldAppointNewIamgeField implements DatabaseEvent {
  final ProductField newImageField;
  DatabaseEventUpdateProductFieldAppointNewIamgeField({
    required this.newImageField,
  });
}

class DatabaseEventUpdateProductUpdatePriceImages implements DatabaseEvent {
  final Map<String, double> priceImages;
  DatabaseEventUpdateProductUpdatePriceImages({required this.priceImages});
}

// Currencies events
// fetch All Currencies
class DatabaseEventFetchAllCurrencies implements DatabaseEvent {}

// add Currencies
class DatabaseEventAddCurrencies implements DatabaseEvent {
  final Currencies currencies;
  DatabaseEventAddCurrencies({required this.currencies});
}

// delet Currencies
class DatabaseEventDeleteCurrencies implements DatabaseEvent {
  final Currencies currencies;
  DatabaseEventDeleteCurrencies({required this.currencies});
}

//Featured products
//fetch all featured products
class DatabaseEventFetchAllFeaturedProducts implements DatabaseEvent {}

class DatabaseEventAddFeaturedProduct implements DatabaseEvent {
  final String productId;
  DatabaseEventAddFeaturedProduct({required this.productId});
}

//delete featured product
class DatabaseEventDeleteFeaturedProduct implements DatabaseEvent {
  final String productId;
  DatabaseEventDeleteFeaturedProduct({required this.productId});
}

//user preferences
// fetch user preferences
class DatabaseEventFetchUserPreferences implements DatabaseEvent {
  final String userId;
  DatabaseEventFetchUserPreferences({required this.userId});
}

// add user preferences
class DatabaseEventAddUserPreference implements DatabaseEvent {
  final String userId;
  final String productId;
  DatabaseEventAddUserPreference({
    required this.userId,
    required this.productId,
  });
}

//delete user preference
class DatabaseEventDeleteUserPreference implements DatabaseEvent {
  final String productId;
  final String userId;
  DatabaseEventDeleteUserPreference({
    required this.productId,
    required this.userId,
  });
}
