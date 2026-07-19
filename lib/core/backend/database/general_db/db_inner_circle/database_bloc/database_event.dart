import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

class DatabaseEventInitialize implements DatabaseEvent {
  final AppAuthUser currentUser;
  DatabaseEventInitialize({required this.currentUser});
}

class DatabaseEventFlushData implements DatabaseEvent {}

// Product events
// fetch all Poducts
class DatabaseEventFetchAllProducts implements DatabaseEvent {}


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

// Currencies events
// fetch All Currencies
class DatabaseEventFetchAllCurrencies implements DatabaseEvent {}

//Featured products
//fetch all featured products
class DatabaseEventFetchAllFeaturedProducts implements DatabaseEvent {}

//user preferences
// fetch user preferences
class DatabaseEventFetchUserPreferences implements DatabaseEvent {
  final String userId;
  DatabaseEventFetchUserPreferences({required this.userId});
}

// add user preferences
class DatabaseEventAddUserPreference implements DatabaseEvent {
  final String userId;
  final Product product;
  DatabaseEventAddUserPreference({required this.userId, required this.product});
}

//delete user preference
class DatabaseEventDeleteUserPreference implements DatabaseEvent {
  final Product product;
  final String userId;
  DatabaseEventDeleteUserPreference({
    required this.product,
    required this.userId,
  });
}
