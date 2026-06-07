library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'delete_product.dart';

part 'add_product_field.dart';

part 'delete_product_field.dart';

part 'add_price_function.dart';

part 'delete_price_function.dart';

part 'add_currencies.dart';

part 'delete_currencies.dart';

part 'add_product_batch.dart';

part 'update_product.dart';

part 'product_field_update.dart';

part 'currencies_update.dart';

part 'price_function_update.dart';

part 'get_all_products_query.dart';

part 'get_product_fields_query.dart';

part 'get_price_function_query.dart';

part 'get_all_currencies_query.dart';







class CrabpayConnectorConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,);
  }
  
  
  DeleteProductVariablesBuilder deleteProduct ({required String id, }) {
    return DeleteProductVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddProductFieldVariablesBuilder addProductField ({required String productId, required int order, required String handler, required String fieldName, }) {
    return AddProductFieldVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,fieldName: fieldName,);
  }
  
  
  DeleteProductFieldVariablesBuilder deleteProductField ({required String id, }) {
    return DeleteProductFieldVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddPriceFunctionVariablesBuilder addPriceFunction ({required String productId, required String name, required String type, required dynamic formulas, required String currency, }) {
    return AddPriceFunctionVariablesBuilder(dataConnect, productId: productId,name: name,type: type,formulas: formulas,currency: currency,);
  }
  
  
  DeletePriceFunctionVariablesBuilder deletePriceFunction ({required String id, }) {
    return DeletePriceFunctionVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddCurrenciesVariablesBuilder addCurrencies ({required String name, required String mainCurrency, required double rub, required double usd, }) {
    return AddCurrenciesVariablesBuilder(dataConnect, name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
  }
  
  
  DeleteCurrenciesVariablesBuilder deleteCurrencies ({required String id, }) {
    return DeleteCurrenciesVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddProductBatchVariablesBuilder addProductBatch ({required String productId, required String description, required String imageUrl, required String productName, required String functionName, required String type, required dynamic formulas, required String currency, }) {
    return AddProductBatchVariablesBuilder(dataConnect, productId: productId,description: description,imageUrl: imageUrl,productName: productName,functionName: functionName,type: type,formulas: formulas,currency: currency,);
  }
  
  
  UpdateProductVariablesBuilder updateProduct ({required String id, required String name, required String description, required String imageUrl, }) {
    return UpdateProductVariablesBuilder(dataConnect, id: id,name: name,description: description,imageUrl: imageUrl,);
  }
  
  
  ProductFieldUpdateVariablesBuilder productFieldUpdate ({required String productId, required int order, required String handler, required String fieldName, }) {
    return ProductFieldUpdateVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,fieldName: fieldName,);
  }
  
  
  CurrenciesUpdateVariablesBuilder currenciesUpdate ({required String id, required String name, required String mainCurrency, required double rub, required double usd, }) {
    return CurrenciesUpdateVariablesBuilder(dataConnect, id: id,name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
  }
  
  
  PriceFunctionUpdateVariablesBuilder priceFunctionUpdate ({required String id, required String productId, required String name, required String type, required dynamic formulas, required String currency, }) {
    return PriceFunctionUpdateVariablesBuilder(dataConnect, id: id,productId: productId,name: name,type: type,formulas: formulas,currency: currency,);
  }
  
  
  GetAllProductsQueryVariablesBuilder getAllProductsQuery () {
    return GetAllProductsQueryVariablesBuilder(dataConnect, );
  }
  
  
  GetProductFieldsQueryVariablesBuilder getProductFieldsQuery ({required String productId, }) {
    return GetProductFieldsQueryVariablesBuilder(dataConnect, productId: productId,);
  }
  
  
  GetPriceFunctionQueryVariablesBuilder getPriceFunctionQuery ({required String productId, }) {
    return GetPriceFunctionQueryVariablesBuilder(dataConnect, productId: productId,);
  }
  
  
  GetAllCurrenciesQueryVariablesBuilder getAllCurrenciesQuery () {
    return GetAllCurrenciesQueryVariablesBuilder(dataConnect, );
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
