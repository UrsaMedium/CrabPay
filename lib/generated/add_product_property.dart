part of 'crabpay_connector.dart';

class AddProductPropertyVariablesBuilder {
  String productId;
  int order;
  AnyValue attributes;
  AnyValue dataHandler;
  String handler;
  String propertyName;

  final FirebaseDataConnect _dataConnect;
  AddProductPropertyVariablesBuilder(this._dataConnect, {required  this.productId,required  this.order,required  this.attributes,required  this.dataHandler,required  this.handler,required  this.propertyName,});
  Deserializer<AddProductPropertyData> dataDeserializer = (dynamic json)  => AddProductPropertyData.fromJson(jsonDecode(json));
  Serializer<AddProductPropertyVariables> varsSerializer = (AddProductPropertyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductPropertyData, AddProductPropertyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductPropertyData, AddProductPropertyVariables> ref() {
    AddProductPropertyVariables vars= AddProductPropertyVariables(productId: productId,order: order,attributes: attributes,dataHandler: dataHandler,handler: handler,propertyName: propertyName,);
    return _dataConnect.mutation("AddProductProperty", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductPropertyProductPropertyInsert {
  final String id;
  AddProductPropertyProductPropertyInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductPropertyProductPropertyInsert otherTyped = other as AddProductPropertyProductPropertyInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductPropertyProductPropertyInsert({
    required this.id,
  });
}

@immutable
class AddProductPropertyData {
  final AddProductPropertyProductPropertyInsert productProperty_insert;
  AddProductPropertyData.fromJson(dynamic json):
  
  productProperty_insert = AddProductPropertyProductPropertyInsert.fromJson(json['productProperty_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductPropertyData otherTyped = other as AddProductPropertyData;
    return productProperty_insert == otherTyped.productProperty_insert;
    
  }
  @override
  int get hashCode => productProperty_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productProperty_insert'] = productProperty_insert.toJson();
    return json;
  }

  AddProductPropertyData({
    required this.productProperty_insert,
  });
}

@immutable
class AddProductPropertyVariables {
  final String productId;
  final int order;
  final AnyValue attributes;
  final AnyValue dataHandler;
  final String handler;
  final String propertyName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductPropertyVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  order = nativeFromJson<int>(json['order']),
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

    final AddProductPropertyVariables otherTyped = other as AddProductPropertyVariables;
    return productId == otherTyped.productId && 
    order == otherTyped.order && 
    attributes == otherTyped.attributes && 
    dataHandler == otherTyped.dataHandler && 
    handler == otherTyped.handler && 
    propertyName == otherTyped.propertyName;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, order.hashCode, attributes.hashCode, dataHandler.hashCode, handler.hashCode, propertyName.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['order'] = nativeToJson<int>(order);
    json['attributes'] = attributes.toJson();
    json['dataHandler'] = dataHandler.toJson();
    json['handler'] = nativeToJson<String>(handler);
    json['propertyName'] = nativeToJson<String>(propertyName);
    return json;
  }

  AddProductPropertyVariables({
    required this.productId,
    required this.order,
    required this.attributes,
    required this.dataHandler,
    required this.handler,
    required this.propertyName,
  });
}

