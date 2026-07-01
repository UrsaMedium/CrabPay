part of 'crabpay_connector.dart';

class DeleteFeaturedProductVariablesBuilder {
  String featuredProductId;

  final FirebaseDataConnect _dataConnect;
  DeleteFeaturedProductVariablesBuilder(this._dataConnect, {required  this.featuredProductId,});
  Deserializer<DeleteFeaturedProductData> dataDeserializer = (dynamic json)  => DeleteFeaturedProductData.fromJson(jsonDecode(json));
  Serializer<DeleteFeaturedProductVariables> varsSerializer = (DeleteFeaturedProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteFeaturedProductData, DeleteFeaturedProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteFeaturedProductData, DeleteFeaturedProductVariables> ref() {
    DeleteFeaturedProductVariables vars= DeleteFeaturedProductVariables(featuredProductId: featuredProductId,);
    return _dataConnect.mutation("DeleteFeaturedProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteFeaturedProductData {
  final int featuredProduct_deleteMany;
  DeleteFeaturedProductData.fromJson(dynamic json):
  
  featuredProduct_deleteMany = nativeFromJson<int>(json['featuredProduct_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFeaturedProductData otherTyped = other as DeleteFeaturedProductData;
    return featuredProduct_deleteMany == otherTyped.featuredProduct_deleteMany;
    
  }
  @override
  int get hashCode => featuredProduct_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['featuredProduct_deleteMany'] = nativeToJson<int>(featuredProduct_deleteMany);
    return json;
  }

  DeleteFeaturedProductData({
    required this.featuredProduct_deleteMany,
  });
}

@immutable
class DeleteFeaturedProductVariables {
  final String featuredProductId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteFeaturedProductVariables.fromJson(Map<String, dynamic> json):
  
  featuredProductId = nativeFromJson<String>(json['featuredProductId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteFeaturedProductVariables otherTyped = other as DeleteFeaturedProductVariables;
    return featuredProductId == otherTyped.featuredProductId;
    
  }
  @override
  int get hashCode => featuredProductId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['featuredProductId'] = nativeToJson<String>(featuredProductId);
    return json;
  }

  DeleteFeaturedProductVariables({
    required this.featuredProductId,
  });
}

