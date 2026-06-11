part of 'crabpay_connector.dart';

class AddProductFieldVariablesBuilder {
  String productId;
  int order;
  Optional<AnyValue> _priceImages = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<List<String>> _expectedData = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
  String handler;
  String fieldName;
  bool isPriceImage;

  final FirebaseDataConnect _dataConnect;  AddProductFieldVariablesBuilder priceImages(AnyValue? t) {
   _priceImages.value = t;
   return this;
  }
  AddProductFieldVariablesBuilder expectedData(List<String>? t) {
   _expectedData.value = t;
   return this;
  }

  AddProductFieldVariablesBuilder(this._dataConnect, {required  this.productId,required  this.order,required  this.handler,required  this.fieldName,required  this.isPriceImage,});
  Deserializer<AddProductFieldData> dataDeserializer = (dynamic json)  => AddProductFieldData.fromJson(jsonDecode(json));
  Serializer<AddProductFieldVariables> varsSerializer = (AddProductFieldVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductFieldData, AddProductFieldVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductFieldData, AddProductFieldVariables> ref() {
    AddProductFieldVariables vars= AddProductFieldVariables(productId: productId,order: order,priceImages: _priceImages,expectedData: _expectedData,handler: handler,fieldName: fieldName,isPriceImage: isPriceImage,);
    return _dataConnect.mutation("AddProductField", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductFieldProductFieldInsert {
  final String id;
  AddProductFieldProductFieldInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductFieldProductFieldInsert otherTyped = other as AddProductFieldProductFieldInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductFieldProductFieldInsert({
    required this.id,
  });
}

@immutable
class AddProductFieldData {
  final AddProductFieldProductFieldInsert productField_insert;
  AddProductFieldData.fromJson(dynamic json):
  
  productField_insert = AddProductFieldProductFieldInsert.fromJson(json['productField_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductFieldData otherTyped = other as AddProductFieldData;
    return productField_insert == otherTyped.productField_insert;
    
  }
  @override
  int get hashCode => productField_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productField_insert'] = productField_insert.toJson();
    return json;
  }

  AddProductFieldData({
    required this.productField_insert,
  });
}

@immutable
class AddProductFieldVariables {
  final String productId;
  final int order;
  late final Optional<AnyValue>priceImages;
  late final Optional<List<String>>expectedData;
  final String handler;
  final String fieldName;
  final bool isPriceImage;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductFieldVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  order = nativeFromJson<int>(json['order']),
  handler = nativeFromJson<String>(json['handler']),
  fieldName = nativeFromJson<String>(json['fieldName']),
  isPriceImage = nativeFromJson<bool>(json['isPriceImage']) {
  
  
  
  
    priceImages = Optional.optional(AnyValue.fromJson, defaultSerializer);
    priceImages.value = json['priceImages'] == null ? null : AnyValue.fromJson(json['priceImages']);
  
  
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

    final AddProductFieldVariables otherTyped = other as AddProductFieldVariables;
    return productId == otherTyped.productId && 
    order == otherTyped.order && 
    priceImages == otherTyped.priceImages && 
    expectedData == otherTyped.expectedData && 
    handler == otherTyped.handler && 
    fieldName == otherTyped.fieldName && 
    isPriceImage == otherTyped.isPriceImage;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, order.hashCode, priceImages.hashCode, expectedData.hashCode, handler.hashCode, fieldName.hashCode, isPriceImage.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['order'] = nativeToJson<int>(order);
    if(priceImages.state == OptionalState.set) {
      json['priceImages'] = priceImages.toJson();
    }
    if(expectedData.state == OptionalState.set) {
      json['expectedData'] = expectedData.toJson();
    }
    json['handler'] = nativeToJson<String>(handler);
    json['fieldName'] = nativeToJson<String>(fieldName);
    json['isPriceImage'] = nativeToJson<bool>(isPriceImage);
    return json;
  }

  AddProductFieldVariables({
    required this.productId,
    required this.order,
    required this.priceImages,
    required this.expectedData,
    required this.handler,
    required this.fieldName,
    required this.isPriceImage,
  });
}

