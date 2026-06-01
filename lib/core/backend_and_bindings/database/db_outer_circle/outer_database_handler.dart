import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OuterDatabaseHandler implements InnerDatabaseHandler {
  // Product
  // fetch all products
  @override
  Future<List<Product>?> fetchAllProducts() async {
    try {
      final productFetrcher = await CrabpayConnectorConnector.instance
          .getAllProductsQuery()
          .execute();
      List<Product> fetchedProducts = [];
      for (var product in productFetrcher.data.products) {
        fetchedProducts.add(
          Product(
            id: product.id,
            name: product.name,
            image: product.imageUrl,
            description: product.description,
          ),
        );
      }
      Fluttertoast.showToast(msg: 'Suck sus');
      return fetchedProducts;
    } catch (e) {
      print('Failed to fetch: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch: $e');
      return null;
    }
  }

  // add Product
  @override
  Future<void> addProduct(Product product) async {
    try {
      await CrabpayConnectorConnector.instance
          .addProduct(
            description: product.description,
            imageUrl: product.image,
            name: product.name,
          )
          .id(product.id == '' ? null : product.id)
          .execute();
    } catch (e) {
      print('Failed to add the product: $e');
      Fluttertoast.showToast(msg: 'Failed to add the product: $e');
    }
  }

  // delete Product
  @override
  Future<void> deleteProduct(Product product) async {
    try {
      CrabpayConnectorConnector.instance.deleteProduct(id: product.id);
    } catch (e) {
      print('Failed to delete the product: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the product: $e');
    }
  }

  // Fields
  // fetch a field
  @override
  Future<void> fetchProductField(String id) async {
    // TODO: implement fetchProductFields
    throw UnimplementedError();
  }

  // fetch product fields
  @override
  Future<List<ProductField>?> fetchProductFields(String productId) async {
    try {
      final fetchedFields = await CrabpayConnectorConnector.instance
          .getProductFieldsQuery(productId: productId)
          .execute();
      List<ProductField> processedFetchedFields = [];
      for (var each in fetchedFields.data.productFields) {
        final attributes = each.attributes?.toJson() == {}
            ? null
            : Map<String, String?>.from(each.attributes?.toJson());
        final expectedData = each.expectedData == []
            ? null
            : each.expectedData?.toList();
        // print(
        //   '    ${each.id}, $productId,  ${each.order},  ${each.fieldName},  ${each.handler}, $attributes, $expectedData',
        // );
        processedFetchedFields.add(
          ProductField(
            id: each.id,
            productId: productId,
            order: each.order,
            fieldName: each.fieldName,
            handler: each.handler,
            attributes: attributes,
            expectedData: expectedData,
          ),
        );
      }
      return processedFetchedFields;
    } catch (e) {
      print('Failed to fetch fields: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch fields: $e');
      return null;
    }
  }

  // add Product Field
  @override
  Future<void> addProductField(ProductField field) async {
    try {
      AnyValue? attributes;
      if (field.attributes != null) {
        attributes = AnyValue(field.attributes!.cast<String, dynamic>());
      }
      List<String>? expectedData;
      if (field.expectedData != null) {
        expectedData = field.expectedData;
      }
      await CrabpayConnectorConnector.instance
          .addProductField(
            productId: field.productId,
            order: field.order,
            handler: field.handler,
            fieldName: field.fieldName,
          )
          .attributes(attributes)
          .expectedData(expectedData)
          .execute();
    } catch (e) {
      print('Failed to add the field: $e');
      Fluttertoast.showToast(msg: 'Failed to add the field: $e');
    }
  }

  // delete a Field
  @override
  Future<void> deleteProductField(ProductField field) async {
    try {
      await CrabpayConnectorConnector.instance
          .deleteProductField(id: field.id)
          .execute();
    } catch (e) {
      print('Failed to delete the field: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the field: $e');
    }
  }

  // Currencies
  // fetch all currencies
  @override
  Future<List<Currencies>?> fetchAllCurencies() async {
    List<Currencies> processedFetchedAllCurrencies = [];
    try {
      final fetchedAllCurrencies = await CrabpayConnectorConnector.instance
          .getAllCurrenciesQuery()
          .execute();
      for (var currencies in fetchedAllCurrencies.data.currenciess) {
        processedFetchedAllCurrencies.add(
          Currencies(
            id: currencies.id,
            mainCurrency: currencies.mainCurrency,
            name: currencies.name,
            rub: currencies.rub,
            usd: currencies.usd,
          ),
        );
      }
      return processedFetchedAllCurrencies;
    } catch (e) {
      print('Failed to fetch all currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch all currencies: $e');
      return null;
    }
  }

  // add currencies
  @override
  Future<void> addCurrencies(Currencies currencies) async {
    try {
      await CrabpayConnectorConnector.instance
          .addCurrencies(
            name: currencies.name,
            mainCurrency: currencies.mainCurrency,
            rub: currencies.rub,
            usd: currencies.usd,
          )
          .execute();
    } catch (e) {
      print('Failed to add the currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to add the currencies: $e');
    }
  }

  // delete a curencies table
  @override
  Future<void> deleteCurrencies(Currencies currencies) async {
    try {
      await CrabpayConnectorConnector.instance
          .deleteCurrencies(id: currencies.id)
          .execute();
    } catch (e) {
      print('Failed to delete the currencies: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the currencies: $e');
    }
  }

  // Price Function
  // fetch product price functions
  @override
  Future<List<PriceFunction>?> fetchPriceFunctions(String productId) async {
    List<PriceFunction> processedFetchedProductPriceFunctions = [];
    try {
      final fetchedProductPriceFunctions = await CrabpayConnectorConnector
          .instance
          .getPriceFunctionQuery(productId: productId)
          .execute();
      for (var priceFunctions
          in fetchedProductPriceFunctions.data.priceFunctions) {
        final formulas = Map<List<String>, double>.from(
          priceFunctions.formulas.toJson(),
        );
        processedFetchedProductPriceFunctions.add(
          PriceFunction(
            id: priceFunctions.id,
            productId: productId,
            name: priceFunctions.name,
            type: priceFunctions.type,
            fomulas: formulas,
            currency: priceFunctions.currency,
          ),
        );
      }
      return processedFetchedProductPriceFunctions;
    } catch (e) {
      print('Failed to fetch product price functions: $e');
      Fluttertoast.showToast(
        msg: 'Failed to fetch product price functions: $e',
      );
      return null;
    }
  }

  @override
  Future<void> addPriceFunction(PriceFunction priceFunction) async {
    try {
      final temp = priceFunction.fomulas.map((key, value) {
        final keysString = key.join(', ');
        return MapEntry(keysString, value);
      });
      final fomulas = AnyValue(temp);

      await CrabpayConnectorConnector.instance
          .addPriceFunction(
            productId: priceFunction.productId,
            name: priceFunction.name,
            type: priceFunction.type,
            formulas: fomulas,
            currency: priceFunction.currency,
          )
          .execute();
    } catch (e) {
      print(
        'Failed to add the price function: $e --------------------------------------------------------------------------',
      );
      Fluttertoast.showToast(msg: 'Failed to add the price function $e');
    }
  }

  @override
  Future<void> deletePriceFunction(PriceFunction priceFunction) async {
    try {
      await CrabpayConnectorConnector.instance
          .deletePriceFunction(id: priceFunction.id)
          .execute();
    } catch (e) {
      print('Failed to delete the price function: $e');
      Fluttertoast.showToast(msg: 'Failed to delete the price function: $e');
    }
  }
}
