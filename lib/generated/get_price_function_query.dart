part of 'crabpay_connector.dart';

class GetPriceFunctionQueryVariablesBuilder {
  String productId;

  final FirebaseDataConnect _dataConnect;
  GetPriceFunctionQueryVariablesBuilder(this._dataConnect, {required  this.productId,});
  Deserializer<GetPriceFunctionQueryData> dataDeserializer = (dynamic json)  => GetPriceFunctionQueryData.fromJson(jsonDecode(json));
  Serializer<GetPriceFunctionQueryVariables> varsSerializer = (GetPriceFunctionQueryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPriceFunctionQueryData, GetPriceFunctionQueryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetPriceFunctionQueryData, GetPriceFunctionQueryVariables> ref() {
    GetPriceFunctionQueryVariables vars= GetPriceFunctionQueryVariables(productId: productId,);
    return _dataConnect.query("GetPriceFunctionQuery", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPriceFunctionQueryPriceFunctions {
  final String productId;
  final String id;
  final String functionImageField;
  final String type;
  final AnyValue formulas;
  final String currency;
  GetPriceFunctionQueryPriceFunctions.fromJson(dynamic json):
  
  productId = nativeFromJson<String>(json['productId']),
  id = nativeFromJson<String>(json['id']),
  functionImageField = nativeFromJson<String>(json['functionImageField']),
  type = nativeFromJson<String>(json['type']),
  formulas = AnyValue.fromJson(json['formulas']),
  currency = nativeFromJson<String>(json['currency']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPriceFunctionQueryPriceFunctions otherTyped = other as GetPriceFunctionQueryPriceFunctions;
    return productId == otherTyped.productId && 
    id == otherTyped.id && 
    functionImageField == otherTyped.functionImageField && 
    type == otherTyped.type && 
    formulas == otherTyped.formulas && 
    currency == otherTyped.currency;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, id.hashCode, functionImageField.hashCode, type.hashCode, formulas.hashCode, currency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['id'] = nativeToJson<String>(id);
    json['functionImageField'] = nativeToJson<String>(functionImageField);
    json['type'] = nativeToJson<String>(type);
    json['formulas'] = formulas.toJson();
    json['currency'] = nativeToJson<String>(currency);
    return json;
  }

  GetPriceFunctionQueryPriceFunctions({
    required this.productId,
    required this.id,
    required this.functionImageField,
    required this.type,
    required this.formulas,
    required this.currency,
  });
}

@immutable
class GetPriceFunctionQueryData {
  final List<GetPriceFunctionQueryPriceFunctions> priceFunctions;
  GetPriceFunctionQueryData.fromJson(dynamic json):
  
  priceFunctions = (json['priceFunctions'] as List<dynamic>)
        .map((e) => GetPriceFunctionQueryPriceFunctions.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPriceFunctionQueryData otherTyped = other as GetPriceFunctionQueryData;
    return priceFunctions == otherTyped.priceFunctions;
    
  }
  @override
  int get hashCode => priceFunctions.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['priceFunctions'] = priceFunctions.map((e) => e.toJson()).toList();
    return json;
  }

  GetPriceFunctionQueryData({
    required this.priceFunctions,
  });
}

@immutable
class GetPriceFunctionQueryVariables {
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPriceFunctionQueryVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPriceFunctionQueryVariables otherTyped = other as GetPriceFunctionQueryVariables;
    return productId == otherTyped.productId;
    
  }
  @override
  int get hashCode => productId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    return json;
  }

  GetPriceFunctionQueryVariables({
    required this.productId,
  });
}

