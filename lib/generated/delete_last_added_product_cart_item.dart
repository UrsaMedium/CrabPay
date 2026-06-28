part of 'crabpay_connector.dart';

class DeleteLastAddedProductCartItemVariablesBuilder {
  String userId;
  String productId;

  final FirebaseDataConnect _dataConnect;
  DeleteLastAddedProductCartItemVariablesBuilder(this._dataConnect, {required  this.userId,required  this.productId,});
  Deserializer<DeleteLastAddedProductCartItemData> dataDeserializer = (dynamic json)  => DeleteLastAddedProductCartItemData.fromJson(jsonDecode(json));
  Serializer<DeleteLastAddedProductCartItemVariables> varsSerializer = (DeleteLastAddedProductCartItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteLastAddedProductCartItemData, DeleteLastAddedProductCartItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteLastAddedProductCartItemData, DeleteLastAddedProductCartItemVariables> ref() {
    DeleteLastAddedProductCartItemVariables vars= DeleteLastAddedProductCartItemVariables(userId: userId,productId: productId,);
    return _dataConnect.mutation("DeleteLastAddedProductCartItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteLastAddedProductCartItemData {
  final int? execute_;
  DeleteLastAddedProductCartItemData.fromJson(dynamic json):
  
  execute_ = json['_execute'] == null ? null : nativeFromJson<int>(json['_execute']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteLastAddedProductCartItemData otherTyped = other as DeleteLastAddedProductCartItemData;
    return execute_ == otherTyped.execute_;
    
  }
  @override
  int get hashCode => execute_.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (execute_ != null) {
      json['_execute'] = nativeToJson<int?>(execute_);
    }
    return json;
  }

  DeleteLastAddedProductCartItemData({
    this.execute_,
  });
}

@immutable
class DeleteLastAddedProductCartItemVariables {
  final String userId;
  final String productId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteLastAddedProductCartItemVariables.fromJson(Map<String, dynamic> json):
  
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

    final DeleteLastAddedProductCartItemVariables otherTyped = other as DeleteLastAddedProductCartItemVariables;
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

  DeleteLastAddedProductCartItemVariables({
    required this.userId,
    required this.productId,
  });
}

