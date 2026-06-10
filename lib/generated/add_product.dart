part of 'crabpay_connector.dart';

class AddProductVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String description;
  String imageUrl;
  String name;
  String currencies;

  final FirebaseDataConnect _dataConnect;
  AddProductVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }

  AddProductVariablesBuilder(this._dataConnect, {required  this.description,required  this.imageUrl,required  this.name,required  this.currencies,});
  Deserializer<AddProductData> dataDeserializer = (dynamic json)  => AddProductData.fromJson(jsonDecode(json));
  Serializer<AddProductVariables> varsSerializer = (AddProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddProductData, AddProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddProductData, AddProductVariables> ref() {
    AddProductVariables vars= AddProductVariables(id: _id,description: description,imageUrl: imageUrl,name: name,currencies: currencies,);
    return _dataConnect.mutation("AddProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddProductProductInsert {
  final String id;
  AddProductProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductProductInsert otherTyped = other as AddProductProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddProductProductInsert({
    required this.id,
  });
}

@immutable
class AddProductData {
  final AddProductProductInsert product_insert;
  AddProductData.fromJson(dynamic json):
  
  product_insert = AddProductProductInsert.fromJson(json['product_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddProductData otherTyped = other as AddProductData;
    return product_insert == otherTyped.product_insert;
    
  }
  @override
  int get hashCode => product_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_insert'] = product_insert.toJson();
    return json;
  }

  AddProductData({
    required this.product_insert,
  });
}

@immutable
class AddProductVariables {
  late final Optional<String>id;
  final String description;
  final String imageUrl;
  final String name;
  final String currencies;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddProductVariables.fromJson(Map<String, dynamic> json):
  
  description = nativeFromJson<String>(json['description']),
  imageUrl = nativeFromJson<String>(json['imageUrl']),
  name = nativeFromJson<String>(json['name']),
  currencies = nativeFromJson<String>(json['currencies']) {
  
  
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

    final AddProductVariables otherTyped = other as AddProductVariables;
    return id == otherTyped.id && 
    description == otherTyped.description && 
    imageUrl == otherTyped.imageUrl && 
    name == otherTyped.name && 
    currencies == otherTyped.currencies;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, description.hashCode, imageUrl.hashCode, name.hashCode, currencies.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['description'] = nativeToJson<String>(description);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['name'] = nativeToJson<String>(name);
    json['currencies'] = nativeToJson<String>(currencies);
    return json;
  }

  AddProductVariables({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.currencies,
  });
}

