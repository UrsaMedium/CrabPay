part of 'crabpay_connector.dart';

class GetUserPreferencesVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetUserPreferencesVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetUserPreferencesData> dataDeserializer = (dynamic json)  => GetUserPreferencesData.fromJson(jsonDecode(json));
  Serializer<GetUserPreferencesVariables> varsSerializer = (GetUserPreferencesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserPreferencesData, GetUserPreferencesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserPreferencesData, GetUserPreferencesVariables> ref() {
    GetUserPreferencesVariables vars= GetUserPreferencesVariables(userId: userId,);
    return _dataConnect.query("GetUserPreferences", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserPreferencesUserPreferences {
  final String? favoriteProductId;
  GetUserPreferencesUserPreferences.fromJson(dynamic json):
  
  favoriteProductId = json['favoriteProductId'] == null ? null : nativeFromJson<String>(json['favoriteProductId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserPreferencesUserPreferences otherTyped = other as GetUserPreferencesUserPreferences;
    return favoriteProductId == otherTyped.favoriteProductId;
    
  }
  @override
  int get hashCode => favoriteProductId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (favoriteProductId != null) {
      json['favoriteProductId'] = nativeToJson<String?>(favoriteProductId);
    }
    return json;
  }

  GetUserPreferencesUserPreferences({
    this.favoriteProductId,
  });
}

@immutable
class GetUserPreferencesData {
  final List<GetUserPreferencesUserPreferences> userPreferences;
  GetUserPreferencesData.fromJson(dynamic json):
  
  userPreferences = (json['userPreferences'] as List<dynamic>)
        .map((e) => GetUserPreferencesUserPreferences.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserPreferencesData otherTyped = other as GetUserPreferencesData;
    return userPreferences == otherTyped.userPreferences;
    
  }
  @override
  int get hashCode => userPreferences.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userPreferences'] = userPreferences.map((e) => e.toJson()).toList();
    return json;
  }

  GetUserPreferencesData({
    required this.userPreferences,
  });
}

@immutable
class GetUserPreferencesVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserPreferencesVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserPreferencesVariables otherTyped = other as GetUserPreferencesVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetUserPreferencesVariables({
    required this.userId,
  });
}

