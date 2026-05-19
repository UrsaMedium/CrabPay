part of 'crabpay_connector.dart';

class DeleteProductFieldVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteProductFieldVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteProductFieldData> dataDeserializer = (dynamic json)  => DeleteProductFieldData.fromJson(jsonDecode(json));
  Serializer<DeleteProductFieldVariables> varsSerializer = (DeleteProductFieldVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteProductFieldData, DeleteProductFieldVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteProductFieldData, DeleteProductFieldVariables> ref() {
    DeleteProductFieldVariables vars= DeleteProductFieldVariables(id: id,);
    return _dataConnect.mutation("DeleteProductField", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteProductFieldProductFieldDelete {
  final String id;
  DeleteProductFieldProductFieldDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductFieldProductFieldDelete otherTyped = other as DeleteProductFieldProductFieldDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProductFieldProductFieldDelete({
    required this.id,
  });
}

@immutable
class DeleteProductFieldData {
  final DeleteProductFieldProductFieldDelete? productField_delete;
  DeleteProductFieldData.fromJson(dynamic json):
  
  productField_delete = json['productField_delete'] == null ? null : DeleteProductFieldProductFieldDelete.fromJson(json['productField_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductFieldData otherTyped = other as DeleteProductFieldData;
    return productField_delete == otherTyped.productField_delete;
    
  }
  @override
  int get hashCode => productField_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (productField_delete != null) {
      json['productField_delete'] = productField_delete!.toJson();
    }
    return json;
  }

  DeleteProductFieldData({
    this.productField_delete,
  });
}

@immutable
class DeleteProductFieldVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteProductFieldVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProductFieldVariables otherTyped = other as DeleteProductFieldVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProductFieldVariables({
    required this.id,
  });
}

