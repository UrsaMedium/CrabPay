part of 'crabpay_connector.dart';

class AddProductBatchVariablesBuilder {
  String productId;
  String description;
  String imageUrl;
  String productName;
  String functionName;
  String type;
  AnyValue formulas;
  String currency;

  final FirebaseDataConnect _dataConnect;
  AddProductBatchVariablesBuilder(this._dataConnect, {required  this.productId,required  this.description,required  this.imageUrl,required  this.productName,required  this.functionName,required  this.type,required  this.formulas,required  this.currency,});
  Deserializer<AddProductBatchData> dataDeserializer = (dynamic json)  => AddProductBatchData.fromJson(jsonDecode(json));
  Serializer<AddProductBatchVariables> varsSerializer = (AddProductBatchVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductBatchData, AddProductBatchVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductBatchData, AddProductBatchVariables> ref() {
    AddProductBatchVariables vars= AddProductBatchVariables(productId: productId,description: description,imageUrl: imageUrl,productName: productName,functionName: functionName,type: type,formulas: formulas,currency: currency,);
    return _dataConnect.mutation("AddProductBatch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductBatchProductInsert {
  final String id;
  AddProductBatchProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductBatchProductInsert otherTyped = other as AddProductBatchProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductBatchProductInsert({
    required this.id,
  });
}

@immutable
class AddProductBatchPriceFunctionInsert {
  final String id;
  AddProductBatchPriceFunctionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductBatchPriceFunctionInsert otherTyped = other as AddProductBatchPriceFunctionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductBatchPriceFunctionInsert({
    required this.id,
  });
}

@immutable
class AddProductBatchData {
  final AddProductBatchProductInsert product_insert;
  final AddProductBatchPriceFunctionInsert priceFunction_insert;
  AddProductBatchData.fromJson(dynamic json):
  
  product_insert = AddProductBatchProductInsert.fromJson(json['product_insert']),
  priceFunction_insert = AddProductBatchPriceFunctionInsert.fromJson(json['priceFunction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductBatchData otherTyped = other as AddProductBatchData;
    return product_insert == otherTyped.product_insert && 
    priceFunction_insert == otherTyped.priceFunction_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([product_insert.hashCode, priceFunction_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    json['priceFunction_insert'] = priceFunction_insert.toJson();
    return json;
  }

  AddProductBatchData({
    required this.product_insert,
    required this.priceFunction_insert,
  });
}

@immutable
class AddProductBatchVariables {
  final String productId;
  final String description;
  final String imageUrl;
  final String productName;
  final String functionName;
  final String type;
  final AnyValue formulas;
  final String currency;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductBatchVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  description = nativeFromJson<String>(json['description']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  productName = nativeFromJson<String>(json['productName']),
  functionName = nativeFromJson<String>(json['functionName']),
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

    final AddProductBatchVariables otherTyped = other as AddProductBatchVariables;
    return productId == otherTyped.productId && 
    description == otherTyped.description && 
    imageUrl == otherTyped.imageUrl && 
    productName == otherTyped.productName && 
    functionName == otherTyped.functionName && 
    type == otherTyped.type && 
    formulas == otherTyped.formulas && 
    currency == otherTyped.currency;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, description.hashCode, imageUrl.hashCode, productName.hashCode, functionName.hashCode, type.hashCode, formulas.hashCode, currency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['description'] = nativeToJson<String>(description);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['productName'] = nativeToJson<String>(productName);
    json['functionName'] = nativeToJson<String>(functionName);
    json['type'] = nativeToJson<String>(type);
    json['formulas'] = formulas.toJson();
    json['currency'] = nativeToJson<String>(currency);
    return json;
  }

  AddProductBatchVariables({
    required this.productId,
    required this.description,
    required this.imageUrl,
    required this.productName,
    required this.functionName,
    required this.type,
    required this.formulas,
    required this.currency,
  });
}

