part of 'crabpay_connector.dart';

class PriceFunctionUpdateVariablesBuilder {
  String id;
  String productId;
  String functionImageField;
  String type;
  AnyValue formulas;
  String currency;

  final FirebaseDataConnect _dataConnect;
  PriceFunctionUpdateVariablesBuilder(this._dataConnect, {required  this.id,required  this.productId,required  this.functionImageField,required  this.type,required  this.formulas,required  this.currency,});
  Deserializer<PriceFunctionUpdateData> dataDeserializer = (dynamic json)  => PriceFunctionUpdateData.fromJson(jsonDecode(json));
  Serializer<PriceFunctionUpdateVariables> varsSerializer = (PriceFunctionUpdateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<PriceFunctionUpdateData, PriceFunctionUpdateVariables>> execute() {
    return ref().execute();
  }

  MutationRef<PriceFunctionUpdateData, PriceFunctionUpdateVariables> ref() {
    PriceFunctionUpdateVariables vars= PriceFunctionUpdateVariables(id: id,productId: productId,functionImageField: functionImageField,type: type,formulas: formulas,currency: currency,);
    return _dataConnect.mutation("priceFunctionUpdate", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class PriceFunctionUpdatePriceFunctionUpdate {
  final String id;
  PriceFunctionUpdatePriceFunctionUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PriceFunctionUpdatePriceFunctionUpdate otherTyped = other as PriceFunctionUpdatePriceFunctionUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  PriceFunctionUpdatePriceFunctionUpdate({
    required this.id,
  });
}

@immutable
class PriceFunctionUpdateData {
  final PriceFunctionUpdatePriceFunctionUpdate? priceFunction_update;
  PriceFunctionUpdateData.fromJson(dynamic json):
  
  priceFunction_update = json['priceFunction_update'] == null ? null : PriceFunctionUpdatePriceFunctionUpdate.fromJson(json['priceFunction_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final PriceFunctionUpdateData otherTyped = other as PriceFunctionUpdateData;
    return priceFunction_update == otherTyped.priceFunction_update;
    
  }
  @override
  int get hashCode => priceFunction_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (priceFunction_update != null) {
      json['priceFunction_update'] = priceFunction_update!.toJson();
    }
    return json;
  }

  PriceFunctionUpdateData({
    this.priceFunction_update,
  });
}

@immutable
class PriceFunctionUpdateVariables {
  final String id;
  final String productId;
  final String functionImageField;
  final String type;
  final AnyValue formulas;
  final String currency;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  PriceFunctionUpdateVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
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

    final PriceFunctionUpdateVariables otherTyped = other as PriceFunctionUpdateVariables;
    return id == otherTyped.id && 
    productId == otherTyped.productId && 
    functionImageField == otherTyped.functionImageField && 
    type == otherTyped.type && 
    formulas == otherTyped.formulas && 
    currency == otherTyped.currency;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productId.hashCode, functionImageField.hashCode, type.hashCode, formulas.hashCode, currency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productId'] = nativeToJson<String>(productId);
    json['functionImageField'] = nativeToJson<String>(functionImageField);
    json['type'] = nativeToJson<String>(type);
    json['formulas'] = formulas.toJson();
    json['currency'] = nativeToJson<String>(currency);
    return json;
  }

  PriceFunctionUpdateVariables({
    required this.id,
    required this.productId,
    required this.functionImageField,
    required this.type,
    required this.formulas,
    required this.currency,
  });
}

