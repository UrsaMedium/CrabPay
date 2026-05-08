part of 'crabpay_connector.dart';

class GetProductPropertiesQueryVariablesBuilder {
  String productId;

  final FirebaseDataConnect _dataConnect;
  GetProductPropertiesQueryVariablesBuilder(this._dataConnect, {required  this.productId,});
  Deserializer<GetProductPropertiesQueryData> dataDeserializer = (dynamic json)  => GetProductPropertiesQueryData.fromJson(jsonDecode(json));
  Serializer<GetProductPropertiesQueryVariables> varsSerializer = (GetProductPropertiesQueryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductPropertiesQueryData, GetProductPropertiesQueryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProductPropertiesQueryData, GetProductPropertiesQueryVariables> ref() {
    GetProductPropertiesQueryVariables vars= GetProductPropertiesQueryVariables(productId: productId,);
    return _dataConnect.query("GetProductPropertiesQuery", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductPropertiesQueryProductProperties {
  final String productId;
  final String id;
  final int order;
  final String propertyName;
  final String handler;
  final AnyValue? attributes;
  final AnyValue? dataHandler;
  GetProductPropertiesQueryProductProperties.fromJson(dynamic json):
  
  productId = nativeFromJson<String>(json['productId']),
  id = nativeFromJson<String>(json['id']),
  order = nativeFromJson<int>(json['order']),
  propertyName = nativeFromJson<String>(json['propertyName']),
  handler = nativeFromJson<String>(json['handler']),
  attributes = json['attributes'] == null ? null : AnyValue.fromJson(json['attributes']),
  dataHandler = json['dataHandler'] == null ? null : AnyValue.fromJson(json['dataHandler']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductPropertiesQueryProductProperties otherTyped = other as GetProductPropertiesQueryProductProperties;
    return productId == otherTyped.productId && 
    id == otherTyped.id && 
    order == otherTyped.order && 
    propertyName == otherTyped.propertyName && 
    handler == otherTyped.handler && 
    attributes == otherTyped.attributes && 
    dataHandler == otherTyped.dataHandler;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, id.hashCode, order.hashCode, propertyName.hashCode, handler.hashCode, attributes.hashCode, dataHandler.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['id'] = nativeToJson<String>(id);
    json['order'] = nativeToJson<int>(order);
    json['propertyName'] = nativeToJson<String>(propertyName);
    json['handler'] = nativeToJson<String>(handler);
    if (attributes != null) {
      json['attributes'] = attributes!.toJson();
    }
    if (dataHandler != null) {
      json['dataHandler'] = dataHandler!.toJson();
    }
    return json;
  }

  GetProductPropertiesQueryProductProperties({
    required this.productId,
    required this.id,
    required this.order,
    required this.propertyName,
    required this.handler,
    this.attributes,
    this.dataHandler,
  });
}

@immutable
class GetProductPropertiesQueryData {
  final List<GetProductPropertiesQueryProductProperties> productProperties;
  GetProductPropertiesQueryData.fromJson(dynamic json):
  
  productProperties = (json['productProperties'] as List<dynamic>)
        .map((e) => GetProductPropertiesQueryProductProperties.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductPropertiesQueryData otherTyped = other as GetProductPropertiesQueryData;
    return productProperties == otherTyped.productProperties;
    
  }
  @override
  int get hashCode => productProperties.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productProperties'] = productProperties.map((e) => e.toJson()).toList();
    return json;
  }

  GetProductPropertiesQueryData({
    required this.productProperties,
  });
}

@immutable
class GetProductPropertiesQueryVariables {
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductPropertiesQueryVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductPropertiesQueryVariables otherTyped = other as GetProductPropertiesQueryVariables;
    return productId == otherTyped.productId;
    
  }
  @override
  int get hashCode => productId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    return json;
  }

  GetProductPropertiesQueryVariables({
    required this.productId,
  });
}

