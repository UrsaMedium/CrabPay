part of 'crabpay_connector.dart';

class GetCartItemsQueryVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  GetCartItemsQueryVariablesBuilder(this._dataConnect, {required  this.userId,});
  Deserializer<GetCartItemsQueryData> dataDeserializer = (dynamic json)  => GetCartItemsQueryData.fromJson(jsonDecode(json));
  Serializer<GetCartItemsQueryVariables> varsSerializer = (GetCartItemsQueryVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetCartItemsQueryData, GetCartItemsQueryVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetCartItemsQueryData, GetCartItemsQueryVariables> ref() {
    GetCartItemsQueryVariables vars= GetCartItemsQueryVariables(userId: userId,);
    return _dataConnect.query("GetCartItemsQuery", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetCartItemsQueryCartItems {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final AnyValue purchaseData;
  final String currency;
  final double checkoutPrice;
  final Timestamp createdAt;
  final String status;
  final String? comment;
  final Timestamp statusChangedAt;
  GetCartItemsQueryCartItems.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  userId = nativeFromJson<String>(json['userId']),
  userName = nativeFromJson<String>(json['userName']),
  productId = nativeFromJson<String>(json['productId']),
  productName = nativeFromJson<String>(json['productName']),
  purchaseData = AnyValue.fromJson(json['purchaseData']),
  currency = nativeFromJson<String>(json['currency']),
  checkoutPrice = nativeFromJson<double>(json['checkoutPrice']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  status = nativeFromJson<String>(json['status']),
  comment = json['comment'] == null ? null : nativeFromJson<String>(json['comment']),
  statusChangedAt = Timestamp.fromJson(json['statusChangedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCartItemsQueryCartItems otherTyped = other as GetCartItemsQueryCartItems;
    return id == otherTyped.id && 
    userId == otherTyped.userId && 
    userName == otherTyped.userName && 
    productId == otherTyped.productId && 
    productName == otherTyped.productName && 
    purchaseData == otherTyped.purchaseData && 
    currency == otherTyped.currency && 
    checkoutPrice == otherTyped.checkoutPrice && 
    createdAt == otherTyped.createdAt && 
    status == otherTyped.status && 
    comment == otherTyped.comment && 
    statusChangedAt == otherTyped.statusChangedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, userName.hashCode, productId.hashCode, productName.hashCode, purchaseData.hashCode, currency.hashCode, checkoutPrice.hashCode, createdAt.hashCode, status.hashCode, comment.hashCode, statusChangedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['userId'] = nativeToJson<String>(userId);
    json['userName'] = nativeToJson<String>(userName);
    json['productId'] = nativeToJson<String>(productId);
    json['productName'] = nativeToJson<String>(productName);
    json['purchaseData'] = purchaseData.toJson();
    json['currency'] = nativeToJson<String>(currency);
    json['checkoutPrice'] = nativeToJson<double>(checkoutPrice);
    json['createdAt'] = createdAt.toJson();
    json['status'] = nativeToJson<String>(status);
    if (comment != null) {
      json['comment'] = nativeToJson<String?>(comment);
    }
    json['statusChangedAt'] = statusChangedAt.toJson();
    return json;
  }

  GetCartItemsQueryCartItems({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.purchaseData,
    required this.currency,
    required this.checkoutPrice,
    required this.createdAt,
    required this.status,
    this.comment,
    required this.statusChangedAt,
  });
}

@immutable
class GetCartItemsQueryData {
  final List<GetCartItemsQueryCartItems> cartItems;
  GetCartItemsQueryData.fromJson(dynamic json):
  
  cartItems = (json['cartItems'] as List<dynamic>)
        .map((e) => GetCartItemsQueryCartItems.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCartItemsQueryData otherTyped = other as GetCartItemsQueryData;
    return cartItems == otherTyped.cartItems;
    
  }
  @override
  int get hashCode => cartItems.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cartItems'] = cartItems.map((e) => e.toJson()).toList();
    return json;
  }

  GetCartItemsQueryData({
    required this.cartItems,
  });
}

@immutable
class GetCartItemsQueryVariables {
  final String userId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetCartItemsQueryVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCartItemsQueryVariables otherTyped = other as GetCartItemsQueryVariables;
    return userId == otherTyped.userId;
    
  }
  @override
  int get hashCode => userId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  GetCartItemsQueryVariables({
    required this.userId,
  });
}

