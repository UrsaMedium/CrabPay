part of 'crabpay_connector.dart';

class GetProductFieldsQueryVariablesBuilder {
  String productId;

  final FirebaseDataConnect _dataConnect;
  GetProductFieldsQueryVariablesBuilder(this._dataConnect, {required  this.productId,});
  Deserializer<GetProductFieldsQueryData> dataDeserializer = (dynamic json)  => GetProductFieldsQueryData.fromJson(jsonDecode(json));
  Serializer<GetProductFieldsQueryVariables> varsSerializer = (GetProductFieldsQueryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductFieldsQueryData, GetProductFieldsQueryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProductFieldsQueryData, GetProductFieldsQueryVariables> ref() {
    GetProductFieldsQueryVariables vars= GetProductFieldsQueryVariables(productId: productId,);
    return _dataConnect.query("GetProductFieldsQuery", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductFieldsQueryProductFields {
  final String productId;
  final String id;
  final int order;
  final String fieldName;
  final bool isPriceImage;
  final String handler;
  final AnyValue? priceImages;
  final List<String>? expectedData;
  GetProductFieldsQueryProductFields.fromJson(dynamic json):
  
  productId = nativeFromJson<String>(json['productId']),
  id = nativeFromJson<String>(json['id']),
  order = nativeFromJson<int>(json['order']),
  fieldName = nativeFromJson<String>(json['fieldName']),
  isPriceImage = nativeFromJson<bool>(json['isPriceImage']),
  handler = nativeFromJson<String>(json['handler']),
  priceImages = json['priceImages'] == null ? null : AnyValue.fromJson(json['priceImages']),
  expectedData = json['expectedData'] == null ? null : (json['expectedData'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductFieldsQueryProductFields otherTyped = other as GetProductFieldsQueryProductFields;
    return productId == otherTyped.productId && 
    id == otherTyped.id && 
    order == otherTyped.order && 
    fieldName == otherTyped.fieldName && 
    isPriceImage == otherTyped.isPriceImage && 
    handler == otherTyped.handler && 
    priceImages == otherTyped.priceImages && 
    expectedData == otherTyped.expectedData;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, id.hashCode, order.hashCode, fieldName.hashCode, isPriceImage.hashCode, handler.hashCode, priceImages.hashCode, expectedData.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['id'] = nativeToJson<String>(id);
    json['order'] = nativeToJson<int>(order);
    json['fieldName'] = nativeToJson<String>(fieldName);
    json['isPriceImage'] = nativeToJson<bool>(isPriceImage);
    json['handler'] = nativeToJson<String>(handler);
    if (priceImages != null) {
      json['priceImages'] = priceImages!.toJson();
    }
    if (expectedData != null) {
      json['expectedData'] = expectedData?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetProductFieldsQueryProductFields({
    required this.productId,
    required this.id,
    required this.order,
    required this.fieldName,
    required this.isPriceImage,
    required this.handler,
    this.priceImages,
    this.expectedData,
  });
}

@immutable
class GetProductFieldsQueryData {
  final List<GetProductFieldsQueryProductFields> productFields;
  GetProductFieldsQueryData.fromJson(dynamic json):
  
  productFields = (json['productFields'] as List<dynamic>)
        .map((e) => GetProductFieldsQueryProductFields.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductFieldsQueryData otherTyped = other as GetProductFieldsQueryData;
    return productFields == otherTyped.productFields;
    
  }
  @override
  int get hashCode => productFields.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productFields'] = productFields.map((e) => e.toJson()).toList();
    return json;
  }

  GetProductFieldsQueryData({
    required this.productFields,
  });
}

@immutable
class GetProductFieldsQueryVariables {
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductFieldsQueryVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductFieldsQueryVariables otherTyped = other as GetProductFieldsQueryVariables;
    return productId == otherTyped.productId;
    
  }
  @override
  int get hashCode => productId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    return json;
  }

  GetProductFieldsQueryVariables({
    required this.productId,
  });
}

