part of 'crabpay_connector.dart';

class CurrenciesUpdateVariablesBuilder {
  String id;
  String name;
  String mainCurrency;
  double rub;
  double usd;

  final FirebaseDataConnect _dataConnect;
  CurrenciesUpdateVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.mainCurrency,required  this.rub,required  this.usd,});
  Deserializer<CurrenciesUpdateData> dataDeserializer = (dynamic json)  => CurrenciesUpdateData.fromJson(jsonDecode(json));
  Serializer<CurrenciesUpdateVariables> varsSerializer = (CurrenciesUpdateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CurrenciesUpdateData, CurrenciesUpdateVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CurrenciesUpdateData, CurrenciesUpdateVariables> ref() {
    CurrenciesUpdateVariables vars= CurrenciesUpdateVariables(id: id,name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
    return _dataConnect.mutation("currenciesUpdate", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CurrenciesUpdateCurrenciesUpdate {
  final String id;
  CurrenciesUpdateCurrenciesUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CurrenciesUpdateCurrenciesUpdate otherTyped = other as CurrenciesUpdateCurrenciesUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CurrenciesUpdateCurrenciesUpdate({
    required this.id,
  });
}

@immutable
class CurrenciesUpdateData {
  final CurrenciesUpdateCurrenciesUpdate? currencies_update;
  CurrenciesUpdateData.fromJson(dynamic json):
  
  currencies_update = json['currencies_update'] == null ? null : CurrenciesUpdateCurrenciesUpdate.fromJson(json['currencies_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CurrenciesUpdateData otherTyped = other as CurrenciesUpdateData;
    return currencies_update == otherTyped.currencies_update;
    
  }
  @override
  int get hashCode => currencies_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (currencies_update != null) {
      json['currencies_update'] = currencies_update!.toJson();
    }
    return json;
  }

  CurrenciesUpdateData({
    this.currencies_update,
  });
}

@immutable
class CurrenciesUpdateVariables {
  final String id;
  final String name;
  final String mainCurrency;
  final double rub;
  final double usd;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CurrenciesUpdateVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  mainCurrency = nativeFromJson<String>(json['mainCurrency']),
  rub = nativeFromJson<double>(json['rub']),
  usd = nativeFromJson<double>(json['usd']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CurrenciesUpdateVariables otherTyped = other as CurrenciesUpdateVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    mainCurrency == otherTyped.mainCurrency && 
    rub == otherTyped.rub && 
    usd == otherTyped.usd;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, mainCurrency.hashCode, rub.hashCode, usd.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['mainCurrency'] = nativeToJson<String>(mainCurrency);
    json['rub'] = nativeToJson<double>(rub);
    json['usd'] = nativeToJson<double>(usd);
    return json;
  }

  CurrenciesUpdateVariables({
    required this.id,
    required this.name,
    required this.mainCurrency,
    required this.rub,
    required this.usd,
  });
}

