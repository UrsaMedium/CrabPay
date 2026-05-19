library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'add_product_field.dart';

part 'delete_product_field.dart';

part 'get_all_products_query.dart';

part 'get_product_fields_query.dart';







class CrabpayConnectorConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, required double price, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,price: price,);
  }
  
  
  AddProductFieldVariablesBuilder addProductField ({required String productId, required int order, required String handler, required String fieldName, }) {
    return AddProductFieldVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,fieldName: fieldName,);
  }
  
  
  DeleteProductFieldVariablesBuilder deleteProductField ({required String id, }) {
    return DeleteProductFieldVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetAllProductsQueryVariablesBuilder getAllProductsQuery () {
    return GetAllProductsQueryVariablesBuilder(dataConnect, );
  }
  
  
  GetProductFieldsQueryVariablesBuilder getProductFieldsQuery ({required String productId, }) {
    return GetProductFieldsQueryVariablesBuilder(dataConnect, productId: productId,);
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
