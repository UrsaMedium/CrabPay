part of 'crabpay_connector.dart';

class AddCartItemVariablesBuilder {
  Optional<String> _id = Optional.optional(nativeFromJson, nativeToJson);
  String userId;
  String userName;
  String productId;
  String productName;
  AnyValue purchaseData;
  String currency;
  double checkoutPrice;
  String status;
  Optional<String> _comment = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  AddCartItemVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  AddCartItemVariablesBuilder comment(String? t) {
   _comment.value = t;
   return this;
  }

  AddCartItemVariablesBuilder(this._dataConnect, {required  this.userId,required  this.userName,required  this.productId,required  this.productName,required  this.purchaseData,required  this.currency,required  this.checkoutPrice,required  this.status,});
  Deserializer<AddCartItemData> dataDeserializer = (dynamic json)  => AddCartItemData.fromJson(jsonDecode(json));
  Serializer<AddCartItemVariables> varsSerializer = (AddCartItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddCartItemData, AddCartItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddCartItemData, AddCartItemVariables> ref() {
    AddCartItemVariables vars= AddCartItemVariables(id: _id,userId: userId,userName: userName,productId: productId,productName: productName,purchaseData: purchaseData,currency: currency,checkoutPrice: checkoutPrice,status: status,comment: _comment,);
    return _dataConnect.mutation("addCartItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddCartItemCartItemInsert {
  final String id;
  AddCartItemCartItemInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCartItemCartItemInsert otherTyped = other as AddCartItemCartItemInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddCartItemCartItemInsert({
    required this.id,
  });
}

@immutable
class AddCartItemData {
  final AddCartItemCartItemInsert cartItem_insert;
  AddCartItemData.fromJson(dynamic json):
  
  cartItem_insert = AddCartItemCartItemInsert.fromJson(json['cartItem_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCartItemData otherTyped = other as AddCartItemData;
    return cartItem_insert == otherTyped.cartItem_insert;
    
  }
  @override
  int get hashCode => cartItem_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cartItem_insert'] = cartItem_insert.toJson();
    return json;
  }

  AddCartItemData({
    required this.cartItem_insert,
  });
}

@immutable
class AddCartItemVariables {
  late final Optional<String>id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final AnyValue purchaseData;
  final String currency;
  final double checkoutPrice;
  final String status;
  late final Optional<String>comment;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddCartItemVariables.fromJson(Map<String, dynamic> json):
  
  userId = nativeFromJson<String>(json['userId']),
  userName = nativeFromJson<String>(json['userName']),
  productId = nativeFromJson<String>(json['productId']),
  productName = nativeFromJson<String>(json['productName']),
  purchaseData = AnyValue.fromJson(json['purchaseData']),
  currency = nativeFromJson<String>(json['currency']),
  checkoutPrice = nativeFromJson<double>(json['checkoutPrice']),
  status = nativeFromJson<String>(json['status']) {
  
  
    id = Optional.optional(nativeFromJson, nativeToJson);
    id.value = json['id'] == null ? null : nativeFromJson<String>(json['id']);
  
  
  
  
  
  
  
  
  
  
    comment = Optional.optional(nativeFromJson, nativeToJson);
    comment.value = json['comment'] == null ? null : nativeFromJson<String>(json['comment']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCartItemVariables otherTyped = other as AddCartItemVariables;
    return id == otherTyped.id && 
    userId == otherTyped.userId && 
    userName == otherTyped.userName && 
    productId == otherTyped.productId && 
    productName == otherTyped.productName && 
    purchaseData == otherTyped.purchaseData && 
    currency == otherTyped.currency && 
    checkoutPrice == otherTyped.checkoutPrice && 
    status == otherTyped.status && 
    comment == otherTyped.comment;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, userName.hashCode, productId.hashCode, productName.hashCode, purchaseData.hashCode, currency.hashCode, checkoutPrice.hashCode, status.hashCode, comment.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if(id.state == OptionalState.set) {
      json['id'] = id.toJson();
    }
    json['userId'] = nativeToJson<String>(userId);
    json['userName'] = nativeToJson<String>(userName);
    json['productId'] = nativeToJson<String>(productId);
    json['productName'] = nativeToJson<String>(productName);
    json['purchaseData'] = purchaseData.toJson();
    json['currency'] = nativeToJson<String>(currency);
    json['checkoutPrice'] = nativeToJson<double>(checkoutPrice);
    json['status'] = nativeToJson<String>(status);
    if(comment.state == OptionalState.set) {
      json['comment'] = comment.toJson();
    }
    return json;
  }

  AddCartItemVariables({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.purchaseData,
    required this.currency,
    required this.checkoutPrice,
    required this.status,
    required this.comment,
  });
}

