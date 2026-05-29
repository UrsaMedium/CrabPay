import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_fields_data/paf_inner_circle/product_model.dart';

// class AppProductController {
//   AppProduct findById(String? id) {
//     return appProducts.firstWhere((product) => product.id == id);
//   }

//   List<AppProduct> get products => appProducts;
// }

class PAFDataHandler {
  PAFDataHandler._() {
    _productList = [];
    _fieldsMap = {};
    _productIdList = [];
    _fieldsIdList = [];
    _fieldsList = [];
  }
  static final PAFDataHandler _instance = PAFDataHandler._();
  factory PAFDataHandler() {
    return _instance;
  }

  late List<AppProduct> _productList;
  late List<String> _productIdList;
  late Map<String, List<AppProductField>> _fieldsMap;
  late List<AppProductField> _fieldsList;
  late List<String> _fieldsIdList;

  void _papEraseData() {
    _productList = [];
    _fieldsMap = {};
    _productIdList = [];
    _fieldsIdList = [];
    _fieldsList = [];
  }

  void dataStuffing(
    List<AppProduct> products,
    Map<String, List<AppProductField>> fields,
  ) {
    _papEraseData();
    _productList = products;
    _fieldsMap = fields;

    for (var eachProduct in _productList) {
      _productIdList.add(eachProduct.id);
      if (_fieldsMap[eachProduct.id] != null) {
        for (var eachField in _fieldsMap[eachProduct.id]!) {
          _fieldsIdList.add(eachField.id);
          _fieldsList.add(eachField);
        }
      }
    }
  }

  List<String> fieldsIdList() {
    return _fieldsIdList;
  }

  List<String> productIdList() {
    return _productIdList;
  }

  List<AppProduct> products() {
    return _productList;
  }

  List<AppProductField>? productFields(String id) {
    return _fieldsMap[id];
  }

  AppProduct productById(String id) {
    return _productList.firstWhere((product) => product.id == id);
  }

  AppProductField fieldById(String id) {
    return _fieldsList.firstWhere((fields) => fields.id == id);
  }
}
