part of 'crabpay_connector.dart';

class UpdateProductFieldVariablesBuilder {
  String id;
  Optional<String> _productId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _order = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _fieldName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<bool> _isPriceImage = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _handler = Optional.optional(nativeFromJson, nativeToJson);
  Optional<AnyValue> _priceImages = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<List<String>> _expectedData = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));

  final FirebaseDataConnect _dataConnect;  UpdateProductFieldVariablesBuilder productId(String? t) {
   _productId.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder order(int? t) {
   _order.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder fieldName(String? t) {
   _fieldName.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder isPriceImage(bool? t) {
   _isPriceImage.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder handler(String? t) {
   _handler.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder priceImages(AnyValue? t) {
   _priceImages.value = t;
   return this;
  }
  UpdateProductFieldVariablesBuilder expectedData(List<String>? t) {
   _expectedData.value = t;
   return this;
  }

  UpdateProductFieldVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateProductFieldData> dataDeserializer = (dynamic json)  => UpdateProductFieldData.fromJson(jsonDecode(json));
  Serializer<UpdateProductFieldVariables> varsSerializer = (UpdateProductFieldVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProductFieldData, UpdateProductFieldVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProductFieldData, UpdateProductFieldVariables> ref() {
    UpdateProductFieldVariables vars= UpdateProductFieldVariables(id: id,productId: _productId,order: _order,fieldName: _fieldName,isPriceImage: _isPriceImage,handler: _handler,priceImages: _priceImages,expectedData: _expectedData,);
    return _dataConnect.mutation("UpdateProductField", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateProductFieldProductFieldUpdate {
  final String id;
  UpdateProductFieldProductFieldUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductFieldProductFieldUpdate otherTyped = other as UpdateProductFieldProductFieldUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateProductFieldProductFieldUpdate({
    required this.id,
  });
}

@immutable
class UpdateProductFieldData {
  final UpdateProductFieldProductFieldUpdate? productField_update;
  UpdateProductFieldData.fromJson(dynamic json):
  
  productField_update = json['productField_update'] == null ? null : UpdateProductFieldProductFieldUpdate.fromJson(json['productField_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductFieldData otherTyped = other as UpdateProductFieldData;
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

  UpdateProductFieldData({
    this.productField_update,
  });
}

@immutable
class UpdateProductFieldVariables {
  final String id;
  late final Optional<String>productId;
  late final Optional<int>order;
  late final Optional<String>fieldName;
  late final Optional<bool>isPriceImage;
  late final Optional<String>handler;
  late final Optional<AnyValue>priceImages;
  late final Optional<List<String>>expectedData;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProductFieldVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    productId = Optional.optional(nativeFromJson, nativeToJson);
    productId.value = json['productId'] == null ? null : nativeFromJson<String>(json['productId']);
  
  
    order = Optional.optional(nativeFromJson, nativeToJson);
    order.value = json['order'] == null ? null : nativeFromJson<int>(json['order']);
  
  
    fieldName = Optional.optional(nativeFromJson, nativeToJson);
    fieldName.value = json['fieldName'] == null ? null : nativeFromJson<String>(json['fieldName']);
  
  
    isPriceImage = Optional.optional(nativeFromJson, nativeToJson);
    isPriceImage.value = json['isPriceImage'] == null ? null : nativeFromJson<bool>(json['isPriceImage']);
  
  
    handler = Optional.optional(nativeFromJson, nativeToJson);
    handler.value = json['handler'] == null ? null : nativeFromJson<String>(json['handler']);
  
  
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

    final UpdateProductFieldVariables otherTyped = other as UpdateProductFieldVariables;
    return id == otherTyped.id && 
    productId == otherTyped.productId && 
    order == otherTyped.order && 
    fieldName == otherTyped.fieldName && 
    isPriceImage == otherTyped.isPriceImage && 
    handler == otherTyped.handler && 
    priceImages == otherTyped.priceImages && 
    expectedData == otherTyped.expectedData;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productId.hashCode, order.hashCode, fieldName.hashCode, isPriceImage.hashCode, handler.hashCode, priceImages.hashCode, expectedData.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(productId.state == OptionalState.set) {
      json['productId'] = productId.toJson();
    }
    if(order.state == OptionalState.set) {
      json['order'] = order.toJson();
    }
    if(fieldName.state == OptionalState.set) {
      json['fieldName'] = fieldName.toJson();
    }
    if(isPriceImage.state == OptionalState.set) {
      json['isPriceImage'] = isPriceImage.toJson();
    }
    if(handler.state == OptionalState.set) {
      json['handler'] = handler.toJson();
    }
    if(priceImages.state == OptionalState.set) {
      json['priceImages'] = priceImages.toJson();
    }
    if(expectedData.state == OptionalState.set) {
      json['expectedData'] = expectedData.toJson();
    }
    return json;
  }

  UpdateProductFieldVariables({
    required this.id,
    required this.productId,
    required this.order,
    required this.fieldName,
    required this.isPriceImage,
    required this.handler,
    required this.priceImages,
    required this.expectedData,
  });
}

