part of 'crabpay_connector.dart';

class AddFeaturedProductVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String featuredProductId;

  final FirebaseDataConnect _dataConnect;
  AddFeaturedProductVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }

  AddFeaturedProductVariablesBuilder(this._dataConnect, {required  this.featuredProductId,});
  Deserializer<AddFeaturedProductData> dataDeserializer = (dynamic json)  => AddFeaturedProductData.fromJson(jsonDecode(json));
  Serializer<AddFeaturedProductVariables> varsSerializer = (AddFeaturedProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddFeaturedProductData, AddFeaturedProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddFeaturedProductData, AddFeaturedProductVariables> ref() {
    AddFeaturedProductVariables vars= AddFeaturedProductVariables(id: _id,featuredProductId: featuredProductId,);
    return _dataConnect.mutation("addFeaturedProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddFeaturedProductFeaturedProductInsert {
  final String id;
  AddFeaturedProductFeaturedProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFeaturedProductFeaturedProductInsert otherTyped = other as AddFeaturedProductFeaturedProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddFeaturedProductFeaturedProductInsert({
    required this.id,
  });
}

@immutable
class AddFeaturedProductData {
  final AddFeaturedProductFeaturedProductInsert featuredProduct_insert;
  AddFeaturedProductData.fromJson(dynamic json):
  
  featuredProduct_insert = AddFeaturedProductFeaturedProductInsert.fromJson(json['featuredProduct_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFeaturedProductData otherTyped = other as AddFeaturedProductData;
    return featuredProduct_insert == otherTyped.featuredProduct_insert;
    
  }
  @override
  int get hashCode => featuredProduct_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['featuredProduct_insert'] = featuredProduct_insert.toJson();
    return json;
  }

  AddFeaturedProductData({
    required this.featuredProduct_insert,
  });
}

@immutable
class AddFeaturedProductVariables {
  late final Optional<String>id;
  final String featuredProductId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddFeaturedProductVariables.fromJson(Map<String, dynamic> json):
  
  featuredProductId = nativeFromJson<String>(json['featuredProductId']) {
  
  
    id = Optional.optional(nativeFromJson, nativeToJson);
    id.value = json['id'] == null ? null : nativeFromJson<String>(json['id']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFeaturedProductVariables otherTyped = other as AddFeaturedProductVariables;
    return id == otherTyped.id && 
    featuredProductId == otherTyped.featuredProductId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, featuredProductId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['featuredProductId'] = nativeToJson<String>(featuredProductId);
    return json;
  }

  AddFeaturedProductVariables({
    required this.id,
    required this.featuredProductId,
  });
}

