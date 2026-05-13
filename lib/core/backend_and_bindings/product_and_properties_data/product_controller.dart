import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/products/data_binding_circle.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/generated/crabpay_connector.dart';

class AppProductController {
  AppProduct findById(String? id) {
    return appProducts.firstWhere((product) => product.id == id);
  }

  List<AppProduct> get products => appProducts;
}

class PAPDataHandler {
  PAPDataHandler._();
  static final PAPDataHandler _instance = PAPDataHandler._();
  factory PAPDataHandler() {
    return _instance;
  }

  List<AppProduct>? _productList;
  Map<String, List<AppProduct>>? _productMap;
  Map<String, List<AppProductProperty>>? _propertiesMap;

  void papEraseData() {
    _productList = [];
    _productMap = {};
    _propertiesMap = {};
  }

  List<AppProduct> productDataConsolidation(
    List<GetAllProductsQueryProducts> fetchedAppProducts,
  ) {
    List<AppProduct> temp = [];
    for (var each in fetchedAppProducts) {
      temp.add(
        AppProduct(
          id: each.id,
          name: each.name,
          image: each.imageUrl,
          description: each.description,
          price: each.price,
        ),
      );
    }
    return temp;
  }
}
