part of 'crabpay_connector.dart';

class AddPriceFunctionVariablesBuilder {
  String productId;
  String functionImageField;
  String type;
  AnyValue formulas;
  String currency;

  final FirebaseDataConnect _dataConnect;
  AddPriceFunctionVariablesBuilder(this._dataConnect, {required  this.productId,required  this.functionImageField,required  this.type,required  this.formulas,required  this.currency,});
  Deserializer<AddPriceFunctionData> dataDeserializer = (dynamic json)  => AddPriceFunctionData.fromJson(jsonDecode(json));
  Serializer<AddPriceFunctionVariables> varsSerializer = (AddPriceFunctionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddPriceFunctionData, AddPriceFunctionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddPriceFunctionData, AddPriceFunctionVariables> ref() {
    AddPriceFunctionVariables vars= AddPriceFunctionVariables(productId: productId,functionImageField: functionImageField,type: type,formulas: formulas,currency: currency,);
    return _dataConnect.mutation("AddPriceFunction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddPriceFunctionPriceFunctionInsert {
  final String id;
  AddPriceFunctionPriceFunctionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPriceFunctionPriceFunctionInsert otherTyped = other as AddPriceFunctionPriceFunctionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddPriceFunctionPriceFunctionInsert({
    required this.id,
  });
}

@immutable
class AddPriceFunctionData {
  final AddPriceFunctionPriceFunctionInsert priceFunction_insert;
  AddPriceFunctionData.fromJson(dynamic json):
  
  priceFunction_insert = AddPriceFunctionPriceFunctionInsert.fromJson(json['priceFunction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddPriceFunctionData otherTyped = other as AddPriceFunctionData;
    return priceFunction_insert == otherTyped.priceFunction_insert;
    
  }
  @override
  int get hashCode => priceFunction_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['priceFunction_insert'] = priceFunction_insert.toJson();
    return json;
  }

  AddPriceFunctionData({
    required this.priceFunction_insert,
  });
}

@immutable
class AddPriceFunctionVariables {
  final String productId;
  final String functionImageField;
  final String type;
  final AnyValue formulas;
  final String currency;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddPriceFunctionVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
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

    final AddPriceFunctionVariables otherTyped = other as AddPriceFunctionVariables;
    return productId == otherTyped.productId && 
    functionImageField == otherTyped.functionImageField && 
    type == otherTyped.type && 
    formulas == otherTyped.formulas && 
    currency == otherTyped.currency;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, functionImageField.hashCode, type.hashCode, formulas.hashCode, currency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['functionImageField'] = nativeToJson<String>(functionImageField);
    json['type'] = nativeToJson<String>(type);
    json['formulas'] = formulas.toJson();
    json['currency'] = nativeToJson<String>(currency);
    return json;
  }

  AddPriceFunctionVariables({
    required this.productId,
    required this.functionImageField,
    required this.type,
    required this.formulas,
    required this.currency,
  });
}

