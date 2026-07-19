import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_fields_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class DatabaseEventAdmin {
  const DatabaseEventAdmin();
}

class DatabaseEventFlushDataAdmin implements DatabaseEventAdmin {}

// Product events

// add Product
class DatabaseEventAddProductAdmin implements DatabaseEventAdmin {
  final Product product;
  DatabaseEventAddProductAdmin({required this.product});
}

// delete Product
class DatabaseEventDeleteProductAdmin implements DatabaseEventAdmin {
  final Product product;
  DatabaseEventDeleteProductAdmin({required this.product});
}

// modify product
class DatabaseEventUpdateProductAdmin implements DatabaseEventAdmin {
  final Product product;
  DatabaseEventUpdateProductAdmin({required this.product});
}

// Fields events

// add Product Field
class DatabaseEventAddProductFieldAdmin implements DatabaseEventAdmin {
  final ProductField productField;
  DatabaseEventAddProductFieldAdmin({required this.productField});
}

// delete Product Field
class DatabaseEventDeleteProductFieldAdmin implements DatabaseEventAdmin {
  final ProductField productField;
  DatabaseEventDeleteProductFieldAdmin({required this.productField});
}

class DatabaseEventUpdateProductFieldAdmin implements DatabaseEventAdmin {
  final ProductField field;
  DatabaseEventUpdateProductFieldAdmin({required this.field});
}

class DatabaseEventUpdateProductFieldSwapImageFieldAdmin
    implements DatabaseEventAdmin {
  final ProductField? oldImageField;
  final ProductField newImageField;
  DatabaseEventUpdateProductFieldSwapImageFieldAdmin({
    this.oldImageField,
    required this.newImageField,
  });
}

// Currencies events

// add Currencies
class DatabaseEventAddCurrenciesAdmin implements DatabaseEventAdmin {
  final Currencies currencies;
  DatabaseEventAddCurrenciesAdmin({required this.currencies});
}

// delet Currencies
class DatabaseEventDeleteCurrenciesAdmin implements DatabaseEventAdmin {
  final Currencies currencies;
  DatabaseEventDeleteCurrenciesAdmin({required this.currencies});
}

//Featured products
//fetch all featured products

class DatabaseEventAddFeaturedProductAdmin implements DatabaseEventAdmin {
  final Product product;
  DatabaseEventAddFeaturedProductAdmin({required this.product});
}

//delete featured product
class DatabaseEventDeleteFeaturedProductAdmin implements DatabaseEventAdmin {
  final Product product;
  DatabaseEventDeleteFeaturedProductAdmin({required this.product});
}