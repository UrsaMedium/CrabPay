library crabpay_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'get_all_products_query.dart';

part 'get_product_fields_query.dart';

part 'get_all_currencies_query.dart';

part 'get_cart_items_query.dart';

part 'get_user_cart_count.dart';

part 'get_product_cart_count.dart';

part 'get_featured_products.dart';

part 'get_user_preferences.dart';

part 'add_product.dart';

part 'delete_product.dart';

part 'update_product.dart';

part 'add_product_field.dart';

part 'delete_product_field.dart';

part 'add_currencies.dart';

part 'delete_currencies.dart';

part 'product_field_update.dart';

part 'currencies_update.dart';

part 'delete_cart_item.dart';

part 'add_cart_item.dart';

part 'add_featured_product.dart';

part 'delete_featured_product.dart';

part 'add_user_preference.dart';

part 'delete_user_preference.dart';

part 'update_cart_item.dart';

part 'delete_last_added_product_cart_item.dart';

part 'update_product_field.dart';







class CrabpayConnectorConnector {
  
  
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
  
  
  GetUserCartCountVariablesBuilder getUserCartCount ({required String userId, }) {
    return GetUserCartCountVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  GetProductCartCountVariablesBuilder getProductCartCount ({required String userId, required String productId, }) {
    return GetProductCartCountVariablesBuilder(dataConnect, userId: userId,productId: productId,);
  }
  
  
  GetFeaturedProductsVariablesBuilder getFeaturedProducts () {
    return GetFeaturedProductsVariablesBuilder(dataConnect, );
  }
  
  
  GetUserPreferencesVariablesBuilder getUserPreferences ({required String userId, }) {
    return GetUserPreferencesVariablesBuilder(dataConnect, userId: userId,);
  }
  
  
  AddProductVariablesBuilder addProduct ({required String description, required String imageUrl, required String name, required String currencies, }) {
    return AddProductVariablesBuilder(dataConnect, description: description,imageUrl: imageUrl,name: name,currencies: currencies,);
  }
  
  
  DeleteProductVariablesBuilder deleteProduct ({required String id, }) {
    return DeleteProductVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpdateProductVariablesBuilder updateProduct ({required String id, }) {
    return UpdateProductVariablesBuilder(dataConnect, id: id,);
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
  
  
  AddFeaturedProductVariablesBuilder addFeaturedProduct ({required String featuredProductId, }) {
    return AddFeaturedProductVariablesBuilder(dataConnect, featuredProductId: featuredProductId,);
  }
  
  
  DeleteFeaturedProductVariablesBuilder deleteFeaturedProduct ({required String featuredProductId, }) {
    return DeleteFeaturedProductVariablesBuilder(dataConnect, featuredProductId: featuredProductId,);
  }
  
  
  AddUserPreferenceVariablesBuilder addUserPreference ({required String userId, required String favoriteProductId, }) {
    return AddUserPreferenceVariablesBuilder(dataConnect, userId: userId,favoriteProductId: favoriteProductId,);
  }
  
  
  DeleteUserPreferenceVariablesBuilder deleteUserPreference ({required String userId, required String favoriteProductId, }) {
    return DeleteUserPreferenceVariablesBuilder(dataConnect, userId: userId,favoriteProductId: favoriteProductId,);
  }
  
  
  UpdateCartItemVariablesBuilder updateCartItem ({required String id, }) {
    return UpdateCartItemVariablesBuilder(dataConnect, id: id,);
  }
  
  
  DeleteLastAddedProductCartItemVariablesBuilder deleteLastAddedProductCartItem ({required String userId, required String productId, }) {
    return DeleteLastAddedProductCartItemVariablesBuilder(dataConnect, userId: userId,productId: productId,);
  }
  
  
  UpdateProductFieldVariablesBuilder updateProductField ({required String id, }) {
    return UpdateProductFieldVariablesBuilder(dataConnect, id: id,);
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
