part of 'crabpay_connector.dart';

class DeleteProductPropertyVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteProductPropertyVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteProductPropertyData> dataDeserializer = (dynamic json)  => DeleteProductPropertyData.fromJson(jsonDecode(json));
  Serializer<DeleteProductPropertyVariables> varsSerializer = (DeleteProductPropertyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteProductPropertyData, DeleteProductPropertyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteProductPropertyData, DeleteProductPropertyVariables> ref() {
    DeleteProductPropertyVariables vars= DeleteProductPropertyVariables(id: id,);
    return _dataConnect.mutation("DeleteProductProperty", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteProductPropertyProductPropertyDelete {
  final String id;
  DeleteProductPropertyProductPropertyDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductPropertyProductPropertyDelete otherTyped = other as DeleteProductPropertyProductPropertyDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProductPropertyProductPropertyDelete({
    required this.id,
  });
}

@immutable
class DeleteProductPropertyData {
  final DeleteProductPropertyProductPropertyDelete? productProperty_delete;
  DeleteProductPropertyData.fromJson(dynamic json):
  
  productProperty_delete = json['productProperty_delete'] == null ? null : DeleteProductPropertyProductPropertyDelete.fromJson(json['productProperty_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductPropertyData otherTyped = other as DeleteProductPropertyData;
    return productProperty_delete == otherTyped.productProperty_delete;
    
  }
  @override
  int get hashCode => productProperty_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (productProperty_delete != null) {
      json['productProperty_delete'] = productProperty_delete!.toJson();
    }
    return json;
  }

  DeleteProductPropertyData({
    this.productProperty_delete,
  });
}

@immutable
class DeleteProductPropertyVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteProductPropertyVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductPropertyVariables otherTyped = other as DeleteProductPropertyVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProductPropertyVariables({
    required this.id,
  });
}

