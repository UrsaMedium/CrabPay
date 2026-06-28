part of 'crabpay_connector.dart';

class GetUserCartCountVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetUserCartCountVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetUserCartCountData> dataDeserializer = (dynamic json)  => GetUserCartCountData.fromJson(jsonDecode(json));
  Serializer<GetUserCartCountVariables> varsSerializer = (GetUserCartCountVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserCartCountData, GetUserCartCountVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserCartCountData, GetUserCartCountVariables> ref() {
    GetUserCartCountVariables vars= GetUserCartCountVariables(userId: userId,);
    return _dataConnect.query("GetUserCartCount", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetUserCartCountOfUserCartItemCounters {
  final int? userCartItemCount;
  GetUserCartCountOfUserCartItemCounters.fromJson(dynamic json):
  
  userCartItemCount = json['userCartItemCount'] == null ? null : nativeFromJson<int>(json['userCartItemCount']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserCartCountOfUserCartItemCounters otherTyped = other as GetUserCartCountOfUserCartItemCounters;
    return userCartItemCount == otherTyped.userCartItemCount;
    
  }
  @override
  int get hashCode => userCartItemCount.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (userCartItemCount != null) {
      json['userCartItemCount'] = nativeToJson<int?>(userCartItemCount);
    }
    return json;
  }

  GetUserCartCountOfUserCartItemCounters({
    this.userCartItemCount,
  });
}

@immutable
class GetUserCartCountData {
  final List<GetUserCartCountOfUserCartItemCounters> ofUserCartItemCounters;
  GetUserCartCountData.fromJson(dynamic json):
  
  ofUserCartItemCounters = (json['ofUserCartItemCounters'] as List<dynamic>)
        .map((e) => GetUserCartCountOfUserCartItemCounters.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserCartCountData otherTyped = other as GetUserCartCountData;
    return ofUserCartItemCounters == otherTyped.ofUserCartItemCounters;
    
  }
  @override
  int get hashCode => ofUserCartItemCounters.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ofUserCartItemCounters'] = ofUserCartItemCounters.map((e) => e.toJson()).toList();
    return json;
  }

  GetUserCartCountData({
    required this.ofUserCartItemCounters,
  });
}

@immutable
class GetUserCartCountVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetUserCartCountVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserCartCountVariables otherTyped = other as GetUserCartCountVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetUserCartCountVariables({
    required this.userId,
  });
}

