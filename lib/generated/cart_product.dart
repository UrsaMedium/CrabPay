part of 'crabpay_connector.dart';

class CartProductVariablesBuilder {
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
  CartProductVariablesBuilder id(String? t) {
   _id.value = t;
   return this;
  }
  CartProductVariablesBuilder comment(String? t) {
   _comment.value = t;
   return this;
  }

  CartProductVariablesBuilder(this._dataConnect, {required  this.userId,required  this.userName,required  this.productId,required  this.productName,required  this.purchaseData,required  this.currency,required  this.checkoutPrice,required  this.status,});
  Deserializer<CartProductData> dataDeserializer = (dynamic json)  => CartProductData.fromJson(jsonDecode(json));
  Serializer<CartProductVariables> varsSerializer = (CartProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CartProductData, CartProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CartProductData, CartProductVariables> ref() {
    CartProductVariables vars= CartProductVariables(id: _id,userId: userId,userName: userName,productId: productId,productName: productName,purchaseData: purchaseData,currency: currency,checkoutPrice: checkoutPrice,status: status,comment: _comment,);
    return _dataConnect.mutation("cartProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CartProductCartProductInsert {
  final String id;
  CartProductCartProductInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CartProductCartProductInsert otherTyped = other as CartProductCartProductInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CartProductCartProductInsert({
    required this.id,
  });
}

@immutable
class CartProductData {
  final CartProductCartProductInsert cartProduct_insert;
  CartProductData.fromJson(dynamic json):
  
  cartProduct_insert = CartProductCartProductInsert.fromJson(json['cartProduct_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CartProductData otherTyped = other as CartProductData;
    return cartProduct_insert == otherTyped.cartProduct_insert;
    
  }
  @override
  int get hashCode => cartProduct_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cartProduct_insert'] = cartProduct_insert.toJson();
    return json;
  }

  CartProductData({
    required this.cartProduct_insert,
  });
}

@immutable
class CartProductVariables {
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
  CartProductVariables.fromJson(Map<String, dynamic> json):
  
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

    final CartProductVariables otherTyped = other as CartProductVariables;
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

  CartProductVariables({
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

