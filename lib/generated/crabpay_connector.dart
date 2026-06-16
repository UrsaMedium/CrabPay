library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'add_product.dart';

part 'delete_product.dart';

part 'add_product_field.dart';

part 'delete_product_field.dart';

part 'add_currencies.dart';

part 'delete_currencies.dart';

part 'update_product.dart';

part 'product_field_update.dart';

part 'currencies_update.dart';

part 'delete_cart_item.dart';

part 'add_cart_item.dart';

part 'get_all_products_query.dart';

part 'get_product_fields_query.dart';

part 'get_all_currencies_query.dart';

part 'get_cart_items_query.dart';







class CrabpayConnectorConnector {
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, required String currencies, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,currencies: currencies,);
  }
  
  
  DeleteProductVariablesBuilder deleteProduct ({required String id, }) {
    return DeleteProductVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddProductFieldVariablesBuilder addProductField ({required String productId, required int order, required String handler, required String fieldName, required bool isPriceImage, }) {
    return AddProductFieldVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,fieldName: fieldName,isPriceImage: isPriceImage,);
  }
  
  
  DeleteProductFieldVariablesBuilder deleteProductField ({required String id, }) {
    return DeleteProductFieldVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddCurrenciesVariablesBuilder addCurrencies ({required String name, required String mainCurrency, required double rub, required double usd, }) {
    return AddCurrenciesVariablesBuilder(dataConnect, name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
  }
  
  
  DeleteCurrenciesVariablesBuilder deleteCurrencies ({required String id, }) {
    return DeleteCurrenciesVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateProductVariablesBuilder updateProduct ({required String id, required String name, required String description, required String imageUrl, required String currencies, }) {
    return UpdateProductVariablesBuilder(dataConnect, id: id,name: name,description: description,imageUrl: imageUrl,currencies: currencies,);
  }
  
  
  ProductFieldUpdateVariablesBuilder productFieldUpdate ({required String productId, required int order, required String handler, required String fieldName, required bool isPriceImage, }) {
    return ProductFieldUpdateVariablesBuilder(dataConnect, productId: productId,order: order,handler: handler,fieldName: fieldName,isPriceImage: isPriceImage,);
  }
  
  
  CurrenciesUpdateVariablesBuilder currenciesUpdate ({required String id, required String name, required String mainCurrency, required double rub, required double usd, }) {
    return CurrenciesUpdateVariablesBuilder(dataConnect, id: id,name: name,mainCurrency: mainCurrency,rub: rub,usd: usd,);
  }
  
  
  DeleteCartItemVariablesBuilder deleteCartItem ({required String id, }) {
    return DeleteCartItemVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddCartItemVariablesBuilder addCartItem ({required String userId, required String userName, required String productId, required String productName, required dynamic purchaseData, required String currency, required double checkoutPrice, required String status, }) {
    return AddCartItemVariablesBuilder(dataConnect, userId: userId,userName: userName,productId: productId,productName: productName,purchaseData: purchaseData,currency: currency,checkoutPrice: checkoutPrice,status: status,);
  }
  
  
  GetAllProductsQueryVariablesBuilder getAllProductsQuery () {
    return GetAllProductsQueryVariablesBuilder(dataConnect, );
  }
  
  
  GetProductFieldsQueryVariablesBuilder getProductFieldsQuery ({required String productId, }) {
    return GetProductFieldsQueryVariablesBuilder(dataConnect, productId: productId,);
  }
  
  
  GetAllCurrenciesQueryVariablesBuilder getAllCurrenciesQuery () {
    return GetAllCurrenciesQueryVariablesBuilder(dataConnect, );
  }
  
  
  GetCartItemsQueryVariablesBuilder getCartItemsQuery ({required String userId, }) {
    return GetCartItemsQueryVariablesBuilder(dataConnect, userId: userId,);
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
