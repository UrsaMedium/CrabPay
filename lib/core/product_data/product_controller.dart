import 'package:crabpay/core/product_data/product_data.dart';
import 'package:crabpay/core/product_data/product_model.dart';

class AppProductController {
  AppProduct findById(String? id) {
    return appProducts.firstWhere((product) => product.id == id);
  }

  List<AppProduct> get products => appProducts;
}
