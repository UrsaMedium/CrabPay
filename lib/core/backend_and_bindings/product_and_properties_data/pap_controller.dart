import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';

// class AppProductController {
//   AppProduct findById(String? id) {
//     return appProducts.firstWhere((product) => product.id == id);
//   }

//   List<AppProduct> get products => appProducts;
// }

class PAPDataHandler {
  PAPDataHandler._() {
    _productList = [];
    _propertiesMap = {};
    _productIdList = [];
  }
  static final PAPDataHandler _instance = PAPDataHandler._();
  factory PAPDataHandler() {
    return _instance;
  }

  late List<AppProduct> _productList;
  late List<String> _productIdList;
  late Map<String, List<AppProductProperty>> _propertiesMap;

  void _papEraseData() {
    _productList = [];
    _propertiesMap = {};
  }

  void dataStuffing(
    List<AppProduct> products,
    Map<String, List<AppProductProperty>> properties,
  ) {
    _papEraseData();
    _productList = products;
    _propertiesMap = properties;

    for (var each in _productList) {
      _productIdList.add(each.id);
    }
  }

  List<String> productIdList() {
    return _productIdList;
  }

  List<AppProduct> products() {
    return _productList;
  }

  List<AppProductProperty>? productProperties(String id) {
    return _propertiesMap[id];
  }

  AppProduct findById(String id) {
    return _productList.firstWhere((product) => product.id == id);
  }
}
