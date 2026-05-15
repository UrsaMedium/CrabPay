library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'add_product_property.dart';

part 'delete_product_property.dart';

part 'get_all_products_query.dart';

part 'get_product_properties_query.dart';







class CrabpayConnectorConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, required double price, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,price: price,);
  }
  
  
  AddProductPropertyVariablesBuilder addProductProperty ({required String productId, required int order, required String handler, required String propertyName, }) {
    return AddProductPropertyVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,propertyName: propertyName,);
  }
  
  
  DeleteProductPropertyVariablesBuilder deleteProductProperty ({required String id, }) {
    return DeleteProductPropertyVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetAllProductsQueryVariablesBuilder getAllProductsQuery () {
    return GetAllProductsQueryVariablesBuilder(dataConnect, );
  }
  
  
  GetProductPropertiesQueryVariablesBuilder getProductPropertiesQuery ({required String productId, }) {
    return GetProductPropertiesQueryVariablesBuilder(dataConnect, productId: productId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'europe-north1',
    'crabpay-connector',
    'crabpay-service',
  );

  CrabpayConnectorConnector({required this.dataConnect});
  static CrabpayConnectorConnector get instance {
    
    return CrabpayConnectorConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
