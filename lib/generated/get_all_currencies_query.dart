part of 'crabpay_connector.dart';

class GetAllCurrenciesQueryVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllCurrenciesQueryVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllCurrenciesQueryData> dataDeserializer = (dynamic json)  => GetAllCurrenciesQueryData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllCurrenciesQueryData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllCurrenciesQueryData, void> ref() {
    
    return _dataConnect.query("GetAllCurrenciesQuery", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllCurrenciesQueryCurrenciess {
  final String id;
  final String name;
  final String mainCurrency;
  final double rub;
  final double usd;
  GetAllCurrenciesQueryCurrenciess.fromJson(dynamic json):
  
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

    final GetAllCurrenciesQueryCurrenciess otherTyped = other as GetAllCurrenciesQueryCurrenciess;
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

  GetAllCurrenciesQueryCurrenciess({
    required this.id,
    required this.name,
    required this.mainCurrency,
    required this.rub,
    required this.usd,
  });
}

@immutable
class GetAllCurrenciesQueryData {
  final List<GetAllCurrenciesQueryCurrenciess> currenciess;
  GetAllCurrenciesQueryData.fromJson(dynamic json):
  
  currenciess = (json['currenciess'] as List<dynamic>)
        .map((e) => GetAllCurrenciesQueryCurrenciess.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllCurrenciesQueryData otherTyped = other as GetAllCurrenciesQueryData;
    return currenciess == otherTyped.currenciess;
    
  }
  @override
  int get hashCode => currenciess.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['currenciess'] = currenciess.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllCurrenciesQueryData({
    required this.currenciess,
  });
}

