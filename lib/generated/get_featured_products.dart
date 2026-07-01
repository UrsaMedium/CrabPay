part of 'crabpay_connector.dart';

class GetFeaturedProductsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetFeaturedProductsVariablesBuilder(this._dataConnect, );
  Deserializer<GetFeaturedProductsData> dataDeserializer = (dynamic json)  => GetFeaturedProductsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetFeaturedProductsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetFeaturedProductsData, void> ref() {
    
    return _dataConnect.query("GetFeaturedProducts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetFeaturedProductsFeaturedProducts {
  final String id;
  final String? featuredProductId;
  GetFeaturedProductsFeaturedProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  featuredProductId = json['featuredProductId'] == null ? null : nativeFromJson<String>(json['featuredProductId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFeaturedProductsFeaturedProducts otherTyped = other as GetFeaturedProductsFeaturedProducts;
    return id == otherTyped.id && 
    featuredProductId == otherTyped.featuredProductId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, featuredProductId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (featuredProductId != null) {
      json['featuredProductId'] = nativeToJson<String?>(featuredProductId);
    }
    return json;
  }

  GetFeaturedProductsFeaturedProducts({
    required this.id,
    this.featuredProductId,
  });
}

@immutable
class GetFeaturedProductsData {
  final List<GetFeaturedProductsFeaturedProducts> featuredProducts;
  GetFeaturedProductsData.fromJson(dynamic json):
  
  featuredProducts = (json['featuredProducts'] as List<dynamic>)
        .map((e) => GetFeaturedProductsFeaturedProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetFeaturedProductsData otherTyped = other as GetFeaturedProductsData;
    return featuredProducts == otherTyped.featuredProducts;
    
  }
  @override
  int get hashCode => featuredProducts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['featuredProducts'] = featuredProducts.map((e) => e.toJson()).toList();
    return json;
  }

  GetFeaturedProductsData({
    required this.featuredProducts,
  });
}

