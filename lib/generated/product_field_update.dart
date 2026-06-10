part of 'crabpay_connector.dart';

class ProductFieldUpdateVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String productId;
  int order;
  Optional<AnyValue> _attributes = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<List<String>> _expectedData = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
  String handler;
  String fieldName;
  bool isPriceImage;

  final FirebaseDataConnect _dataConnect;
  ProductFieldUpdateVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  ProductFieldUpdateVariablesBuilder attributes(AnyValue? t) {
   _attributes.value = t;
   return this;
  }
  ProductFieldUpdateVariablesBuilder expectedData(List<String>? t) {
   _expectedData.value = t;
   return this;
  }

  ProductFieldUpdateVariablesBuilder(this._dataConnect, {required  this.productId,required  this.order,required  this.handler,required  this.fieldName,required  this.isPriceImage,});
  Deserializer<ProductFieldUpdateData> dataDeserializer = (dynamic json)  => ProductFieldUpdateData.fromJson(jsonDecode(json));
  Serializer<ProductFieldUpdateVariables> varsSerializer = (ProductFieldUpdateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ProductFieldUpdateData, ProductFieldUpdateVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ProductFieldUpdateData, ProductFieldUpdateVariables> ref() {
    ProductFieldUpdateVariables vars= ProductFieldUpdateVariables(id: _id,productId: productId,order: order,attributes: _attributes,expectedData: _expectedData,handler: handler,fieldName: fieldName,isPriceImage: isPriceImage,);
    return _dataConnect.mutation("productFieldUpdate", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ProductFieldUpdateProductFieldUpdate {
  final String id;
  ProductFieldUpdateProductFieldUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ProductFieldUpdateProductFieldUpdate otherTyped = other as ProductFieldUpdateProductFieldUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ProductFieldUpdateProductFieldUpdate({
    required this.id,
  });
}

@immutable
class ProductFieldUpdateData {
  final ProductFieldUpdateProductFieldUpdate? productField_update;
  ProductFieldUpdateData.fromJson(dynamic json):
  
  productField_update = json['productField_update'] == null ? null : ProductFieldUpdateProductFieldUpdate.fromJson(json['productField_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ProductFieldUpdateData otherTyped = other as ProductFieldUpdateData;
    return productField_update == otherTyped.productField_update;
    
  }
  @override
  int get hashCode => productField_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (productField_update != null) {
      json['productField_update'] = productField_update!.toJson();
    }
    return json;
  }

  ProductFieldUpdateData({
    this.productField_update,
  });
}

@immutable
class ProductFieldUpdateVariables {
  late final Optional<String>id;
  final String productId;
  final int order;
  late final Optional<AnyValue>attributes;
  late final Optional<List<String>>expectedData;
  final String handler;
  final String fieldName;
  final bool isPriceImage;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ProductFieldUpdateVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  order = nativeFromJson<int>(json['order']),
  handler = nativeFromJson<String>(json['handler']),
  fieldName = nativeFromJson<String>(json['fieldName']),
  isPriceImage = nativeFromJson<bool>(json['isPriceImage']) {
  
  
    id = Optional.optional(nativeFromJson, nativeToJson);
    id.value = json['id'] == null ? null : nativeFromJson<String>(json['id']);
  
  
  
  
    attributes = Optional.optional(AnyValue.fromJson, defaultSerializer);
    attributes.value = json['attributes'] == null ? null : AnyValue.fromJson(json['attributes']);
  
  
    expectedData = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
    expectedData.value = json['expectedData'] == null ? null : (json['expectedData'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ProductFieldUpdateVariables otherTyped = other as ProductFieldUpdateVariables;
    return id == otherTyped.id && 
    productId == otherTyped.productId && 
    order == otherTyped.order && 
    attributes == otherTyped.attributes && 
    expectedData == otherTyped.expectedData && 
    handler == otherTyped.handler && 
    fieldName == otherTyped.fieldName && 
    isPriceImage == otherTyped.isPriceImage;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productId.hashCode, order.hashCode, attributes.hashCode, expectedData.hashCode, handler.hashCode, fieldName.hashCode, isPriceImage.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['productId'] = nativeToJson<String>(productId);
    json['order'] = nativeToJson<int>(order);
    if(attributes.state == OptionalState.set) {
      json['attributes'] = attributes.toJson();
    }
    if(expectedData.state == OptionalState.set) {
      json['expectedData'] = expectedData.toJson();
    }
    json['handler'] = nativeToJson<String>(handler);
    json['fieldName'] = nativeToJson<String>(fieldName);
    json['isPriceImage'] = nativeToJson<bool>(isPriceImage);
    return json;
  }

  ProductFieldUpdateVariables({
    required this.id,
    required this.productId,
    required this.order,
    required this.attributes,
    required this.expectedData,
    required this.handler,
    required this.fieldName,
    required this.isPriceImage,
  });
}

