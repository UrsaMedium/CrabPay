part of 'crabpay_connector.dart';

class AddProductPropertiesToProductVariablesBuilder {
  String productId;
  AnyValue attributes;
  AnyValue dataHandler;
  String handler;
  String propertyName;

  final FirebaseDataConnect _dataConnect;
  AddProductPropertiesToProductVariablesBuilder(this._dataConnect, {required  this.productId,required  this.attributes,required  this.dataHandler,required  this.handler,required  this.propertyName,});
  Deserializer<AddProductPropertiesToProductData> dataDeserializer = (dynamic json)  => AddProductPropertiesToProductData.fromJson(jsonDecode(json));
  Serializer<AddProductPropertiesToProductVariables> varsSerializer = (AddProductPropertiesToProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductPropertiesToProductData, AddProductPropertiesToProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductPropertiesToProductData, AddProductPropertiesToProductVariables> ref() {
    AddProductPropertiesToProductVariables vars= AddProductPropertiesToProductVariables(productId: productId,attributes: attributes,dataHandler: dataHandler,handler: handler,propertyName: propertyName,);
    return _dataConnect.mutation("AddProductPropertiesToProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductPropertiesToProductProductPropertiesInsert {
  final String id;
  AddProductPropertiesToProductProductPropertiesInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductPropertiesToProductProductPropertiesInsert otherTyped = other as AddProductPropertiesToProductProductPropertiesInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductPropertiesToProductProductPropertiesInsert({
    required this.id,
  });
}

@immutable
class AddProductPropertiesToProductData {
  final AddProductPropertiesToProductProductPropertiesInsert productProperties_insert;
  AddProductPropertiesToProductData.fromJson(dynamic json):
  
  productProperties_insert = AddProductPropertiesToProductProductPropertiesInsert.fromJson(json['productProperties_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductPropertiesToProductData otherTyped = other as AddProductPropertiesToProductData;
    return productProperties_insert == otherTyped.productProperties_insert;
    
  }
  @override
  int get hashCode => productProperties_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productProperties_insert'] = productProperties_insert.toJson();
    return json;
  }

  AddProductPropertiesToProductData({
    required this.productProperties_insert,
  });
}

@immutable
class AddProductPropertiesToProductVariables {
  final String productId;
  final AnyValue attributes;
  final AnyValue dataHandler;
  final String handler;
  final String propertyName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductPropertiesToProductVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  attributes = AnyValue.fromJson(json['attributes']),
  dataHandler = AnyValue.fromJson(json['dataHandler']),
  handler = nativeFromJson<String>(json['handler']),
  propertyName = nativeFromJson<String>(json['propertyName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductPropertiesToProductVariables otherTyped = other as AddProductPropertiesToProductVariables;
    return productId == otherTyped.productId && 
    attributes == otherTyped.attributes && 
    dataHandler == otherTyped.dataHandler && 
    handler == otherTyped.handler && 
    propertyName == otherTyped.propertyName;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, attributes.hashCode, dataHandler.hashCode, handler.hashCode, propertyName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['attributes'] = attributes.toJson();
    json['dataHandler'] = dataHandler.toJson();
    json['handler'] = nativeToJson<String>(handler);
    json['propertyName'] = nativeToJson<String>(propertyName);
    return json;
  }

  AddProductPropertiesToProductVariables({
    required this.productId,
    required this.attributes,
    required this.dataHandler,
    required this.handler,
    required this.propertyName,
  });
}

