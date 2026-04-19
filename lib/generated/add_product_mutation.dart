part of 'crabpay_connector.dart';

class AddProductMutationVariablesBuilder {
  String productId;
  String name;
  double price;
  Optional<String> _description = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _imageUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  AddProductMutationVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  AddProductMutationVariablesBuilder imageUrl(String? t) {
   _imageUrl.value = t;
   return this;
  }

  AddProductMutationVariablesBuilder(this._dataConnect, {required  this.productId,required  this.name,required  this.price,});
  Deserializer<AddProductMutationData> dataDeserializer = (dynamic json)  => AddProductMutationData.fromJson(jsonDecode(json));
  Serializer<AddProductMutationVariables> varsSerializer = (AddProductMutationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductMutationData, AddProductMutationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductMutationData, AddProductMutationVariables> ref() {
    AddProductMutationVariables vars= AddProductMutationVariables(productId: productId,name: name,price: price,description: _description,imageUrl: _imageUrl,);
    return _dataConnect.mutation("addProductMutation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductMutationProductInsert {
  final String id;
  AddProductMutationProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductMutationProductInsert otherTyped = other as AddProductMutationProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductMutationProductInsert({
    required this.id,
  });
}

@immutable
class AddProductMutationData {
  final AddProductMutationProductInsert product_insert;
  AddProductMutationData.fromJson(dynamic json):
  
  product_insert = AddProductMutationProductInsert.fromJson(json['product_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductMutationData otherTyped = other as AddProductMutationData;
    return product_insert == otherTyped.product_insert;
    
  }
  @override
  int get hashCode => product_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    return json;
  }

  AddProductMutationData({
    required this.product_insert,
  });
}

@immutable
class AddProductMutationVariables {
  final String productId;
  final String name;
  final double price;
  late final Optional<String>description;
  late final Optional<String>imageUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductMutationVariables.fromJson(Map<String, dynamic> json):
  
  productId = nativeFromJson<String>(json['productId']),
  name = nativeFromJson<String>(json['name']),
  price = nativeFromJson<double>(json['price']) {
  
  
  
  
  
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  
  
    imageUrl = Optional.optional(nativeFromJson, nativeToJson);
    imageUrl.value = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductMutationVariables otherTyped = other as AddProductMutationVariables;
    return productId == otherTyped.productId && 
    name == otherTyped.name && 
    price == otherTyped.price && 
    description == otherTyped.description && 
    imageUrl == otherTyped.imageUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([productId.hashCode, name.hashCode, price.hashCode, description.hashCode, imageUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productId'] = nativeToJson<String>(productId);
    json['name'] = nativeToJson<String>(name);
    json['price'] = nativeToJson<double>(price);
    if(description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    if(imageUrl.state == OptionalState.set) {
      json['imageUrl'] = imageUrl.toJson();
    }
    return json;
  }

  AddProductMutationVariables({
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

