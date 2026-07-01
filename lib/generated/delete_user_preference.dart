part of 'crabpay_connector.dart';

class DeleteUserPreferenceVariablesBuilder {
  String userId;
  String favoriteProductId;

  final FirebaseDataConnect _dataConnect;
  DeleteUserPreferenceVariablesBuilder(this._dataConnect, {required  this.userId,required  this.favoriteProductId,});
  Deserializer<DeleteUserPreferenceData> dataDeserializer = (dynamic json)  => DeleteUserPreferenceData.fromJson(jsonDecode(json));
  Serializer<DeleteUserPreferenceVariables> varsSerializer = (DeleteUserPreferenceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteUserPreferenceData, DeleteUserPreferenceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteUserPreferenceData, DeleteUserPreferenceVariables> ref() {
    DeleteUserPreferenceVariables vars= DeleteUserPreferenceVariables(userId: userId,favoriteProductId: favoriteProductId,);
    return _dataConnect.mutation("DeleteUserPreference", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteUserPreferenceUserPreferenceDelete {
  final String id;
  DeleteUserPreferenceUserPreferenceDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUserPreferenceUserPreferenceDelete otherTyped = other as DeleteUserPreferenceUserPreferenceDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteUserPreferenceUserPreferenceDelete({
    required this.id,
  });
}

@immutable
class DeleteUserPreferenceData {
  final DeleteUserPreferenceUserPreferenceDelete? userPreference_delete;
  DeleteUserPreferenceData.fromJson(dynamic json):
  
  userPreference_delete = json['userPreference_delete'] == null ? null : DeleteUserPreferenceUserPreferenceDelete.fromJson(json['userPreference_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUserPreferenceData otherTyped = other as DeleteUserPreferenceData;
    return userPreference_delete == otherTyped.userPreference_delete;
    
  }
  @override
  int get hashCode => userPreference_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (userPreference_delete != null) {
      json['userPreference_delete'] = userPreference_delete!.toJson();
    }
    return json;
  }

  DeleteUserPreferenceData({
    this.userPreference_delete,
  });
}

@immutable
class DeleteUserPreferenceVariables {
  final String userId;
  final String favoriteProductId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteUserPreferenceVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  favoriteProductId = nativeFromJson<String>(json['favoriteProductId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteUserPreferenceVariables otherTyped = other as DeleteUserPreferenceVariables;
    return userId == otherTyped.userId && 
    favoriteProductId == otherTyped.favoriteProductId;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, favoriteProductId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['favoriteProductId'] = nativeToJson<String>(favoriteProductId);
    return json;
  }

  DeleteUserPreferenceVariables({
    required this.userId,
    required this.favoriteProductId,
  });
}

