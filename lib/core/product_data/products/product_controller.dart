import 'package:crabpay/core/product_data/products/data_binding_circle.dart';
import 'package:crabpay/core/product_data/products/product_model.dart';

class AppProductController {
  AppProduct findById(String? id) {
    return appProducts.firstWhere((product) => product.id == id);
  }

  List<AppProduct> get products => appProducts;
}
