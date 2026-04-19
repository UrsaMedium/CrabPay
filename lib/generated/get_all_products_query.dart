part of 'crabpay_connector.dart';

class GetAllProductsQueryVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllProductsQueryVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllProductsQueryData> dataDeserializer = (dynamic json)  => GetAllProductsQueryData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllProductsQueryData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllProductsQueryData, void> ref() {
    
    return _dataConnect.query("GetAllProductsQuery", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllProductsQueryProducts {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  GetAllProductsQueryProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  price = nativeFromJson<double>(json['price']),
  imageUrl = json['imageUrl'] == null ? null : nativeFromJson<String>(json['imageUrl']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllProductsQueryProducts otherTyped = other as GetAllProductsQueryProducts;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    price == otherTyped.price && 
    imageUrl == otherTyped.imageUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, price.hashCode, imageUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['price'] = nativeToJson<double>(price);
    if (imageUrl != null) {
      json['imageUrl'] = nativeToJson<String?>(imageUrl);
    }
    return json;
  }

  GetAllProductsQueryProducts({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
  });
}

@immutable
class GetAllProductsQueryData {
  final List<GetAllProductsQueryProducts> products;
  GetAllProductsQueryData.fromJson(dynamic json):
  
  products = (json['products'] as List<dynamic>)
        .map((e) => GetAllProductsQueryProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllProductsQueryData otherTyped = other as GetAllProductsQueryData;
    return products == otherTyped.products;
    
  }
  @override
  int get hashCode => products.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['products'] = products.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllProductsQueryData({
    required this.products,
  });
}

