library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'add_product_properties_to_product.dart';

part 'get_all_products_query.dart';







class CrabpayConnectorConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, required double price, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,price: price,);
  }
  
  
  AddProductPropertiesToProductVariablesBuilder addProductPropertiesToProduct ({required String productId, required dynamic attributes, required dynamic dataHandler, required String handler, required String propertyName, }) {
    return AddProductPropertiesToProductVariablesBuilder(dataConnect, productId: productId,attributes: attributes,dataHandler: dataHandler,handler: handler,propertyName: propertyName,);
  }
  
  
  GetAllProductsQueryVariablesBuilder getAllProductsQuery () {
    return GetAllProductsQueryVariablesBuilder(dataConnect, );
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
