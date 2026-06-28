part of 'crabpay_connector.dart';

class GetProductCartCountVariablesBuilder {
  String userId;
  String productId;

  final FirebaseDataConnect _dataConnect;
  GetProductCartCountVariablesBuilder(this._dataConnect, {required  this.userId,required  this.productId,});
  Deserializer<GetProductCartCountData> dataDeserializer = (dynamic json)  => GetProductCartCountData.fromJson(jsonDecode(json));
  Serializer<GetProductCartCountVariables> varsSerializer = (GetProductCartCountVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductCartCountData, GetProductCartCountVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetProductCartCountData, GetProductCartCountVariables> ref() {
    GetProductCartCountVariables vars= GetProductCartCountVariables(userId: userId,productId: productId,);
    return _dataConnect.query("GetProductCartCount", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductCartCountOfUserOfProductCartItemCounters {
  final int? productCartItemCount;
  GetProductCartCountOfUserOfProductCartItemCounters.fromJson(dynamic json):
  
  productCartItemCount = json['productCartItemCount'] == null ? null : nativeFromJson<int>(json['productCartItemCount']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductCartCountOfUserOfProductCartItemCounters otherTyped = other as GetProductCartCountOfUserOfProductCartItemCounters;
    return productCartItemCount == otherTyped.productCartItemCount;
    
  }
  @override
  int get hashCode => productCartItemCount.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (productCartItemCount != null) {
      json['productCartItemCount'] = nativeToJson<int?>(productCartItemCount);
    }
    return json;
  }

  GetProductCartCountOfUserOfProductCartItemCounters({
    this.productCartItemCount,
  });
}

@immutable
class GetProductCartCountData {
  final List<GetProductCartCountOfUserOfProductCartItemCounters> ofUserOfProductCartItemCounters;
  GetProductCartCountData.fromJson(dynamic json):
  
  ofUserOfProductCartItemCounters = (json['ofUserOfProductCartItemCounters'] as List<dynamic>)
        .map((e) => GetProductCartCountOfUserOfProductCartItemCounters.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductCartCountData otherTyped = other as GetProductCartCountData;
    return ofUserOfProductCartItemCounters == otherTyped.ofUserOfProductCartItemCounters;
    
  }
  @override
  int get hashCode => ofUserOfProductCartItemCounters.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ofUserOfProductCartItemCounters'] = ofUserOfProductCartItemCounters.map((e) => e.toJson()).toList();
    return json;
  }

  GetProductCartCountData({
    required this.ofUserOfProductCartItemCounters,
  });
}

@immutable
class GetProductCartCountVariables {
  final String userId;
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductCartCountVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  productId = nativeFromJson<String>(json['productId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductCartCountVariables otherTyped = other as GetProductCartCountVariables;
    return userId == otherTyped.userId && 
    productId == otherTyped.productId;
    
  }
  @override
  int get hashCode => Object.hashAll([userId.hashCode, productId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['productId'] = nativeToJson<String>(productId);
    return json;
  }

  GetProductCartCountVariables({
    required this.userId,
    required this.productId,
  });
}

