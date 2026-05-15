part of 'crabpay_connector.dart';

class AddProductPropertyVariablesBuilder {
  String productId;
  int order;
  Optional<AnyValue> _attributes = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<AnyValue> _dataHandler = Optional.optional(AnyValue.fromJson, defaultSerializer);
  String handler;
  String propertyName;

  final FirebaseDataConnect _dataConnect;  AddProductPropertyVariablesBuilder attributes(AnyValue? t) {
   _attributes.value = t;
   return this;
  }
  AddProductPropertyVariablesBuilder dataHandler(AnyValue? t) {
   _dataHandler.value = t;
   return this;
  }

  AddProductPropertyVariablesBuilder(this._dataConnect, {required  this.productId,required  this.order,required  this.handler,required  this.propertyName,});
  Deserializer<AddProductPropertyData> dataDeserializer = (dynamic json)  => AddProductPropertyData.fromJson(jsonDecode(json));
  Serializer<AddProductPropertyVariables> varsSerializer = (AddProductPropertyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductPropertyData, AddProductPropertyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductPropertyData, AddProductPropertyVariables> ref() {
    AddProductPropertyVariables vars= AddProductPropertyVariables(productId: productId,order: order,attributes: _attributes,dataHandler: _dataHandler,handler: handler,propertyName: propertyName,);
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
  late final Optional<AnyValue>attributes;
  late final Optional<AnyValue>dataHandler;
  final String handler;
  final String propertyName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductPropertyVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  order = nativeFromJson<int>(json['order']),
  handler = nativeFromJson<String>(json['handler']),
  propertyName = nativeFromJson<String>(json['propertyName']) {
  
  
  
  
    attributes = Optional.optional(AnyValue.fromJson, defaultSerializer);
    attributes.value = json['attributes'] == null ? null : AnyValue.fromJson(json['attributes']);
  
  
    dataHandler = Optional.optional(AnyValue.fromJson, defaultSerializer);
    dataHandler.value = json['dataHandler'] == null ? null : AnyValue.fromJson(json['dataHandler']);
  
  
  
  }
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
    if(attributes.state == OptionalState.set) {
      json['attributes'] = attributes.toJson();
    }
    if(dataHandler.state == OptionalState.set) {
      json['dataHandler'] = dataHandler.toJson();
    }
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

