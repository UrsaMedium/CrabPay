import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';

class DatabaseDataHandler {
  DatabaseDataHandler._() {
    _productList = [];
    _fieldsMap = {};
    _productIdList = [];
    _fieldsIdList = [];
    _fieldsList = [];
  }
  static final DatabaseDataHandler _instance = DatabaseDataHandler._();
  factory DatabaseDataHandler() {
    return _instance;
  }

  late List<AppProduct> _productList;
  late List<String> _productIdList;
  late Map<String, List<AppProductField>> _fieldsMap;
  late List<AppProductField> _fieldsList;
  late List<String> _fieldsIdList;

  void _dbEraseData() {
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
    _dbEraseData();
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
