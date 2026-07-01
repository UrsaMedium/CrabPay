part of 'crabpay_connector.dart';

class AddUserPreferenceVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String userId;
  String favoriteProductId;

  final FirebaseDataConnect _dataConnect;
  AddUserPreferenceVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }

  AddUserPreferenceVariablesBuilder(this._dataConnect, {required  this.userId,required  this.favoriteProductId,});
  Deserializer<AddUserPreferenceData> dataDeserializer = (dynamic json)  => AddUserPreferenceData.fromJson(jsonDecode(json));
  Serializer<AddUserPreferenceVariables> varsSerializer = (AddUserPreferenceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddUserPreferenceData, AddUserPreferenceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddUserPreferenceData, AddUserPreferenceVariables> ref() {
    AddUserPreferenceVariables vars= AddUserPreferenceVariables(id: _id,userId: userId,favoriteProductId: favoriteProductId,);
    return _dataConnect.mutation("addUserPreference", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddUserPreferenceUserPreferenceInsert {
  final String id;
  AddUserPreferenceUserPreferenceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddUserPreferenceUserPreferenceInsert otherTyped = other as AddUserPreferenceUserPreferenceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddUserPreferenceUserPreferenceInsert({
    required this.id,
  });
}

@immutable
class AddUserPreferenceData {
  final AddUserPreferenceUserPreferenceInsert userPreference_insert;
  AddUserPreferenceData.fromJson(dynamic json):
  
  userPreference_insert = AddUserPreferenceUserPreferenceInsert.fromJson(json['userPreference_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddUserPreferenceData otherTyped = other as AddUserPreferenceData;
    return userPreference_insert == otherTyped.userPreference_insert;
    
  }
  @override
  int get hashCode => userPreference_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userPreference_insert'] = userPreference_insert.toJson();
    return json;
  }

  AddUserPreferenceData({
    required this.userPreference_insert,
  });
}

@immutable
class AddUserPreferenceVariables {
  late final Optional<String>id;
  final String userId;
  final String favoriteProductId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddUserPreferenceVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  favoriteProductId = nativeFromJson<String>(json['favoriteProductId']) {
  
  
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

    final AddUserPreferenceVariables otherTyped = other as AddUserPreferenceVariables;
    return id == otherTyped.id && 
    userId == otherTyped.userId && 
    favoriteProductId == otherTyped.favoriteProductId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, favoriteProductId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['userId'] = nativeToJson<String>(userId);
    json['favoriteProductId'] = nativeToJson<String>(favoriteProductId);
    return json;
  }

  AddUserPreferenceVariables({
    required this.id,
    required this.userId,
    required this.favoriteProductId,
  });
}

