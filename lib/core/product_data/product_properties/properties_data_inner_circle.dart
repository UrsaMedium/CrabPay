import 'package:crabpay/core/product_data/product_properties/product_properties_model.dart';
import 'package:crabpay/core/product_data/product_properties/properties_data_binding_circle.dart';

List<AppProductPropertiers> propertiesByProduct(String productId) {
  return appProductPropertires
      .where((property) => property.productId == productId)
      .toList();
}
