part of 'crabpay_connector.dart';

class DeleteCurrenciesVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteCurrenciesVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteCurrenciesData> dataDeserializer = (dynamic json)  => DeleteCurrenciesData.fromJson(jsonDecode(json));
  Serializer<DeleteCurrenciesVariables> varsSerializer = (DeleteCurrenciesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteCurrenciesData, DeleteCurrenciesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteCurrenciesData, DeleteCurrenciesVariables> ref() {
    DeleteCurrenciesVariables vars= DeleteCurrenciesVariables(id: id,);
    return _dataConnect.mutation("DeleteCurrencies", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteCurrenciesCurrenciesDelete {
  final String id;
  DeleteCurrenciesCurrenciesDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrenciesCurrenciesDelete otherTyped = other as DeleteCurrenciesCurrenciesDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCurrenciesCurrenciesDelete({
    required this.id,
  });
}

@immutable
class DeleteCurrenciesData {
  final DeleteCurrenciesCurrenciesDelete? currencies_delete;
  DeleteCurrenciesData.fromJson(dynamic json):
  
  currencies_delete = json['currencies_delete'] == null ? null : DeleteCurrenciesCurrenciesDelete.fromJson(json['currencies_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrenciesData otherTyped = other as DeleteCurrenciesData;
    return currencies_delete == otherTyped.currencies_delete;
    
  }
  @override
  int get hashCode => currencies_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (currencies_delete != null) {
      json['currencies_delete'] = currencies_delete!.toJson();
    }
    return json;
  }

  DeleteCurrenciesData({
    this.currencies_delete,
  });
}

@immutable
class DeleteCurrenciesVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteCurrenciesVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCurrenciesVariables otherTyped = other as DeleteCurrenciesVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCurrenciesVariables({
    required this.id,
  });
}

