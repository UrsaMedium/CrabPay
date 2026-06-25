part of 'crabpay_connector.dart';

class UpdateCartItemVariablesBuilder {
  String id;
  Optional<String> _userId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _userName = Optional.optional(nativeFromJson, nativeToJson);
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
    UpdateCartItemVariables vars= UpdateCartItemVariables(id: id,userId: _userId,userName: _userName,status: _status,comment: _comment,statusChangedAt: _statusChangedAt,);
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
    status == otherTyped.status && 
    comment == otherTyped.comment && 
    statusChangedAt == otherTyped.statusChangedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, userId.hashCode, userName.hashCode, status.hashCode, comment.hashCode, statusChangedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(userId.state == OptionalState.set) {
      json['userId'] = userId.toJson();
    }
    if(userName.state == OptionalState.set) {
      json['userName'] = userName.toJson();
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
    required this.status,
    required this.comment,
    required this.statusChangedAt,
  });
}

