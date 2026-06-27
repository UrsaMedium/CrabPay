part of 'crabpay_connector.dart';

class UpdateProductVariablesBuilder {
  String id;
  Optional<String> _name = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _description = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _imageUrl = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _currencies = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpdateProductVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpdateProductVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }
  UpdateProductVariablesBuilder imageUrl(String? t) {
   _imageUrl.value = t;
   return this;
  }
  UpdateProductVariablesBuilder currencies(String? t) {
   _currencies.value = t;
   return this;
  }

  UpdateProductVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateProductData> dataDeserializer = (dynamic json)  => UpdateProductData.fromJson(jsonDecode(json));
  Serializer<UpdateProductVariables> varsSerializer = (UpdateProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProductData, UpdateProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProductData, UpdateProductVariables> ref() {
    UpdateProductVariables vars= UpdateProductVariables(id: id,name: _name,description: _description,imageUrl: _imageUrl,currencies: _currencies,);
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
  late final Optional<String>name;
  late final Optional<String>description;
  late final Optional<String>imageUrl;
  late final Optional<String>currencies;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProductVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null ? null : nativeFromJson<String>(json['name']);
  
  
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  
  
    imageUrl = Optional.optional(nativeFromJson, nativeToJson);
    imageUrl.value = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']);
  
  
    currencies = Optional.optional(nativeFromJson, nativeToJson);
    currencies.value = json['currencies'] == null ? null : nativeFromJson<String>(json['currencies']);
  
  }
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
    if(name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if(description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    if(imageUrl.state == OptionalState.set) {
      json['imageUrl'] = imageUrl.toJson();
    }
    if(currencies.state == OptionalState.set) {
      json['currencies'] = currencies.toJson();
    }
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

