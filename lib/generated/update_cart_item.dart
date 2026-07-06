part of 'crabpay_connector.dart';

class UpdateCartItemVariablesBuilder {
  String id;
  Optional<String> _userId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _userName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _productId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _productName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<AnyValue> _purchaseData = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<String> _currency = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _checkoutPrice = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _status = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _comment = Optional.optional(nativeFromJson, nativeToJson);
  Optional<Timestamp> _statusChangedAt = Optional.optional((json) => json['statusChangedAt'] = Timestamp.fromJson(json['statusChangedAt']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;  UpdateCartItemVariablesBuilder userId(String? t) {
   _userId.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder userName(String? t) {
   _userName.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder productId(String? t) {
   _productId.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder productName(String? t) {
   _productName.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder purchaseData(AnyValue? t) {
   _purchaseData.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder currency(String? t) {
   _currency.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder checkoutPrice(double? t) {
   _checkoutPrice.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder status(String? t) {
   _status.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder comment(String? t) {
   _comment.value = t;
   return this;
  }
  UpdateCartItemVariablesBuilder statusChangedAt(Timestamp? t) {
   _statusChangedAt.value = t;
   return this;
  }

  UpdateCartItemVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpdateCartItemData> dataDeserializer = (dynamic json)  => UpdateCartItemData.fromJson(jsonDecode(json));
  Serializer<UpdateCartItemVariables> varsSerializer = (UpdateCartItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCartItemData, UpdateCartItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateCartItemData, UpdateCartItemVariables> ref() {
    UpdateCartItemVariables vars= UpdateCartItemVariables(id: id,userId: _userId,userName: _userName,productId: _productId,productName: _productName,purchaseData: _purchaseData,currency: _currency,checkoutPrice: _checkoutPrice,status: _status,comment: _comment,statusChangedAt: _statusChangedAt,);
    return _dataConnect.mutation("UpdateCartItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateCartItemCartItemUpdate {
  final String id;
  UpdateCartItemCartItemUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCartItemCartItemUpdate otherTyped = other as UpdateCartItemCartItemUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateCartItemCartItemUpdate({
    required this.id,
  });
}

@immutable
class UpdateCartItemData {
  final UpdateCartItemCartItemUpdate? cartItem_update;
  UpdateCartItemData.fromJson(dynamic json):
  
  cartItem_update = json['cartItem_update'] == null ? null : UpdateCartItemCartItemUpdate.fromJson(json['cartItem_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCartItemData otherTyped = other as UpdateCartItemData;
    return cartItem_update == otherTyped.cartItem_update;
    
  }
  @override
  int get hashCode => cartItem_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (cartItem_update != null) {
      json['cartItem_update'] = cartItem_update!.toJson();
    }
    return json;
  }

  UpdateCartItemData({
    this.cartItem_update,
  });
}

@immutable
class UpdateCartItemVariables {
  final String id;
  late final Optional<String>userId;
  late final Optional<String>userName;
  late final Optional<String>productId;
  late final Optional<String>productName;
  late final Optional<AnyValue>purchaseData;
  late final Optional<String>currency;
  late final Optional<double>checkoutPrice;
  late final Optional<String>status;
  late final Optional<String>comment;
  late final Optional<Timestamp>statusChangedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateCartItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    userId = Optional.optional(nativeFromJson, nativeToJson);
    userId.value = json['userId'] == null ? null : nativeFromJson<String>(json['userId']);
  
  
    userName = Optional.optional(nativeFromJson, nativeToJson);
    userName.value = json['userName'] == null ? null : nativeFromJson<String>(json['userName']);
  
  
    productId = Optional.optional(nativeFromJson, nativeToJson);
    productId.value = json['productId'] == null ? null : nativeFromJson<String>(json['productId']);
  
  
    productName = Optional.optional(nativeFromJson, nativeToJson);
    productName.value = json['productName'] == null ? null : nativeFromJson<String>(json['productName']);
  
  
    purchaseData = Optional.optional(AnyValue.fromJson, defaultSerializer);
    purchaseData.value = json['purchaseData'] == null ? null : AnyValue.fromJson(json['purchaseData']);
  
  
    currency = Optional.optional(nativeFromJson, nativeToJson);
    currency.value = json['currency'] == null ? null : nativeFromJson<String>(json['currency']);
  
  
    checkoutPrice = Optional.optional(nativeFromJson, nativeToJson);
    checkoutPrice.value = json['checkoutPrice'] == null ? null : nativeFromJson<double>(json['checkoutPrice']);
  
  
    status = Optional.optional(nativeFromJson, nativeToJson);
    status.value = json['status'] == null ? null : nativeFromJson<String>(json['status']);
  
  
    comment = Optional.optional(nativeFromJson, nativeToJson);
    comment.value = json['comment'] == null ? null : nativeFromJson<String>(json['comment']);
  
  
    statusChangedAt = Optional.optional((json) => json['statusChangedAt'] = Timestamp.fromJson(json['statusChangedAt']), defaultSerializer);
    statusChangedAt.value = json['statusChangedAt'] == null ? null : Timestamp.fromJson(json['statusChangedAt']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCartItemVariables otherTyped = other as UpdateCartItemVariables;
    return id == otherTyped.id && 
    userId == otherTyped.userId && 
    userName == otherTyped.userName && 
    productId == otherTyped.productId && 
    productName == otherTyped.productName && 
    purchaseData == otherTyped.purchaseData && 
    currency == otherTyped.currency && 
    checkoutPrice == otherTyped.checkoutPrice && 
    status == otherTyped.status && 
    comment == otherTyped.comment && 
    statusChangedAt == otherTyped.statusChangedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, userName.hashCode, productId.hashCode, productName.hashCode, purchaseData.hashCode, currency.hashCode, checkoutPrice.hashCode, status.hashCode, comment.hashCode, statusChangedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(userId.state == OptionalState.set) {
      json['userId'] = userId.toJson();
    }
    if(userName.state == OptionalState.set) {
      json['userName'] = userName.toJson();
    }
    if(productId.state == OptionalState.set) {
      json['productId'] = productId.toJson();
    }
    if(productName.state == OptionalState.set) {
      json['productName'] = productName.toJson();
    }
    if(purchaseData.state == OptionalState.set) {
      json['purchaseData'] = purchaseData.toJson();
    }
    if(currency.state == OptionalState.set) {
      json['currency'] = currency.toJson();
    }
    if(checkoutPrice.state == OptionalState.set) {
      json['checkoutPrice'] = checkoutPrice.toJson();
    }
    if(status.state == OptionalState.set) {
      json['status'] = status.toJson();
    }
    if(comment.state == OptionalState.set) {
      json['comment'] = comment.toJson();
    }
    if(statusChangedAt.state == OptionalState.set) {
      json['statusChangedAt'] = statusChangedAt.toJson();
    }
    return json;
  }

  UpdateCartItemVariables({
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
    required this.statusChangedAt,
  });
}

