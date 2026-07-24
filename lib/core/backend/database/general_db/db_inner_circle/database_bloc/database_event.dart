import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DatabaseEvent {
  const DatabaseEvent();
}

class DatabaseEventInitialize extends DatabaseEvent {
  final AppAuthUser currentUser;
  const DatabaseEventInitialize({required this.currentUser});
}

class DatabaseEventFlushUserData extends DatabaseEvent {}

// Product events
// fetch all Poducts
class DatabaseEventFetchAllProducts extends DatabaseEvent {}

// Fields events
// fetch Product Fields
class DatabaseEventFetchProductFields extends DatabaseEvent {
  final String productId;
  const DatabaseEventFetchProductFields({required this.productId});
}

// fetch Product Field
class DatabaseEventFetchProductField extends DatabaseEvent {
  final String productFieldId;
  const DatabaseEventFetchProductField({required this.productFieldId});
}

// Currencies events
// fetch All Currencies
class DatabaseEventFetchAllCurrencies extends DatabaseEvent {}

//Featured products
//fetch all featured products
class DatabaseEventFetchAllFeaturedProducts extends DatabaseEvent {}

//user preferences
// fetch user preferences
class DatabaseEventFetchUserPreferences extends DatabaseEvent {
  final String userId;
  const DatabaseEventFetchUserPreferences({required this.userId});
}

// add user preferences
class DatabaseEventAddUserPreference extends DatabaseEvent {
  final String userId;
  final Product product;
  const DatabaseEventAddUserPreference({
    required this.userId,
    required this.product,
  });
}

//delete user preference
class DatabaseEventDeleteUserPreference extends DatabaseEvent {
  final Product product;
  final String userId;
  const DatabaseEventDeleteUserPreference({
    required this.product,
    required this.userId,
  });
}

//Card tint color
class DatabaseEventGetProductCardTintColor extends DatabaseEvent {
  final Product product;
  const DatabaseEventGetProductCardTintColor({required this.product});
}
