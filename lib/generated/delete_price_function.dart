part of 'crabpay_connector.dart';

class DeletePriceFunctionVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeletePriceFunctionVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeletePriceFunctionData> dataDeserializer = (dynamic json)  => DeletePriceFunctionData.fromJson(jsonDecode(json));
  Serializer<DeletePriceFunctionVariables> varsSerializer = (DeletePriceFunctionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeletePriceFunctionData, DeletePriceFunctionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeletePriceFunctionData, DeletePriceFunctionVariables> ref() {
    DeletePriceFunctionVariables vars= DeletePriceFunctionVariables(id: id,);
    return _dataConnect.mutation("DeletePriceFunction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeletePriceFunctionPriceFunctionDelete {
  final String id;
  DeletePriceFunctionPriceFunctionDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePriceFunctionPriceFunctionDelete otherTyped = other as DeletePriceFunctionPriceFunctionDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeletePriceFunctionPriceFunctionDelete({
    required this.id,
  });
}

@immutable
class DeletePriceFunctionData {
  final DeletePriceFunctionPriceFunctionDelete? priceFunction_delete;
  DeletePriceFunctionData.fromJson(dynamic json):
  
  priceFunction_delete = json['priceFunction_delete'] == null ? null : DeletePriceFunctionPriceFunctionDelete.fromJson(json['priceFunction_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePriceFunctionData otherTyped = other as DeletePriceFunctionData;
    return priceFunction_delete == otherTyped.priceFunction_delete;
    
  }
  @override
  int get hashCode => priceFunction_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (priceFunction_delete != null) {
      json['priceFunction_delete'] = priceFunction_delete!.toJson();
    }
    return json;
  }

  DeletePriceFunctionData({
    this.priceFunction_delete,
  });
}

@immutable
class DeletePriceFunctionVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeletePriceFunctionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePriceFunctionVariables otherTyped = other as DeletePriceFunctionVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeletePriceFunctionVariables({
    required this.id,
  });
}

