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
    _propertiesIdList = [];
    _propertiesList = [];
  }
  static final PAPDataHandler _instance = PAPDataHandler._();
  factory PAPDataHandler() {
    return _instance;
  }

  late List<AppProduct> _productList;
  late List<String> _productIdList;
  late Map<String, List<AppProductProperty>> _propertiesMap;
  late List<AppProductProperty> _propertiesList;
  late List<String> _propertiesIdList;

  void _papEraseData() {
    _productList = [];
    _propertiesMap = {};
    _productIdList = [];
    _propertiesIdList = [];
    _propertiesList = [];
  }

  void dataStuffing(
    List<AppProduct> products,
    Map<String, List<AppProductProperty>> properties,
  ) {
    _papEraseData();
    _productList = products;
    _propertiesMap = properties;

    for (var eachProduct in _productList) {
      _productIdList.add(eachProduct.id);
      if (_propertiesMap[eachProduct.id] != null) {
        for (var eachProperty in _propertiesMap[eachProduct.id]!) {
          _propertiesIdList.add(eachProperty.id);
          _propertiesList.add(eachProperty);
        }
      }
    }
  }

  List<String> propertiesIdList() {
    return _propertiesIdList;
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

  AppProduct productById(String id) {
    return _productList.firstWhere((product) => product.id == id);
  }

  AppProductProperty propertyById(String id) {
    return _propertiesList.firstWhere((property) => property.id == id);
  }
}
