part of 'crabpay_connector.dart';

class AddCurrenciesVariablesBuilder {
  String name;
  String mainCurrency;
  double rub;
  double usd;

  final FirebaseDataConnect _dataConnect;
  AddCurrenciesVariablesBuilder(this._dataConnect, {required  this.name,required  this.mainCurrency,required  this.rub,required  this.usd,});
  Deserializer<AddCurrenciesData> dataDeserializer = (dynamic json)  => AddCurrenciesData.fromJson(jsonDecode(json));
  Serializer<AddCurrenciesVariables> varsSerializer = (AddCurrenciesVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddCurrenciesData, AddCurrenciesVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddCurrenciesData, AddCurrenciesVariables> ref() {
    AddCurrenciesVariables vars= AddCurrenciesVariables(name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
    return _dataConnect.mutation("AddCurrencies", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddCurrenciesCurrenciesInsert {
  final String id;
  AddCurrenciesCurrenciesInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCurrenciesCurrenciesInsert otherTyped = other as AddCurrenciesCurrenciesInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddCurrenciesCurrenciesInsert({
    required this.id,
  });
}

@immutable
class AddCurrenciesData {
  final AddCurrenciesCurrenciesInsert currencies_insert;
  AddCurrenciesData.fromJson(dynamic json):
  
  currencies_insert = AddCurrenciesCurrenciesInsert.fromJson(json['currencies_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddCurrenciesData otherTyped = other as AddCurrenciesData;
    return currencies_insert == otherTyped.currencies_insert;
    
  }
  @override
  int get hashCode => currencies_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['currencies_insert'] = currencies_insert.toJson();
    return json;
  }

  AddCurrenciesData({
    required this.currencies_insert,
  });
}

@immutable
class AddCurrenciesVariables {
  final String name;
  final String mainCurrency;
  final double rub;
  final double usd;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddCurrenciesVariables.fromJson(Map<String, dynamic> json):
  
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

    final AddCurrenciesVariables otherTyped = other as AddCurrenciesVariables;
    return name == otherTyped.name && 
    mainCurrency == otherTyped.mainCurrency && 
    rub == otherTyped.rub && 
    usd == otherTyped.usd;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, mainCurrency.hashCode, rub.hashCode, usd.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['mainCurrency'] = nativeToJson<String>(mainCurrency);
    json['rub'] = nativeToJson<double>(rub);
    json['usd'] = nativeToJson<double>(usd);
    return json;
  }

  AddCurrenciesVariables({
    required this.name,
    required this.mainCurrency,
    required this.rub,
    required this.usd,
  });
}

