part of 'crabpay_connector.dart';

class UpdateProductVariablesBuilder {
  String id;
  String name;
  String description;
  String imageUrl;
  String currencies;

  final FirebaseDataConnect _dataConnect;
  UpdateProductVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.description,required  this.imageUrl,required  this.currencies,});
  Deserializer<UpdateProductData> dataDeserializer = (dynamic json)  => UpdateProductData.fromJson(jsonDecode(json));
  Serializer<UpdateProductVariables> varsSerializer = (UpdateProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProductData, UpdateProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProductData, UpdateProductVariables> ref() {
    UpdateProductVariables vars= UpdateProductVariables(id: id,name: name,description: description,imageUrl: imageUrl,currencies: currencies,);
    return _dataConnect.mutation("UpdateProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateProductProductUpdate {
  final String id;
  UpdateProductProductUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductProductUpdate otherTyped = other as UpdateProductProductUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateProductProductUpdate({
    required this.id,
  });
}

@immutable
class UpdateProductData {
  final UpdateProductProductUpdate? product_update;
  UpdateProductData.fromJson(dynamic json):
  
  product_update = json['product_update'] == null ? null : UpdateProductProductUpdate.fromJson(json['product_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductData otherTyped = other as UpdateProductData;
    return product_update == otherTyped.product_update;
    
  }
  @override
  int get hashCode => product_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (product_update != null) {
      json['product_update'] = product_update!.toJson();
    }
    return json;
  }

  UpdateProductData({
    this.product_update,
  });
}

@immutable
class UpdateProductVariables {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String currencies;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProductVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  currencies = nativeFromJson<String>(json['currencies']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProductVariables otherTyped = other as UpdateProductVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    imageUrl == otherTyped.imageUrl && 
    currencies == otherTyped.currencies;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, imageUrl.hashCode, currencies.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['currencies'] = nativeToJson<String>(currencies);
    return json;
  }

  UpdateProductVariables({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.currencies,
  });
}

