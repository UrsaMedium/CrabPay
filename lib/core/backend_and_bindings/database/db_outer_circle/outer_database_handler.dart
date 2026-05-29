import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/currencies_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/inner_database_handler.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/price_function_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_inner_circle/data_models/product_fields_model.dart';
import 'package:crabpay/core/backend_and_bindings/database/db_controller.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OuterDatabaseHandler implements InnerDatabaseHandler {
  @override
  Future<void> addProduct(AppProduct product) async {
    try {
      await CrabpayConnectorConnector.instance
          .addProduct(
            description: product.description,
            imageUrl: product.image,
            name: product.name,
          )
          .execute();
      fetchAllProductsAndFieldsData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> addProductField(AppProductField field) async {
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
      fetchAllProductsAndFieldsData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> deleteProduct(AppProduct product) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProductField(AppProductField field) async {
    try {
      await CrabpayConnectorConnector.instance
          .deleteProductField(id: field.id)
          .execute();
      fetchAllProductsAndFieldsData();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> fetchAllProductsAndFieldsData() async {
    try {
      final productFetrcher = await CrabpayConnectorConnector.instance
          .getAllProductsQuery()
          .execute();
      final fetchedAppProducts = _productDataConsolidation(
        productFetrcher.data.products,
      );

      Map<String, List<AppProductField>> allFetchedAppProductFields = {};
      for (var each in fetchedAppProducts) {
        final fieldFetcher = await CrabpayConnectorConnector.instance
            .getProductFieldsQuery(productId: each.id)
            .execute();
        final fetchedPtoperties = _fieldsDataConsolidation(
          fieldFetcher.data.productFields,
        );
        allFetchedAppProductFields[each.id] = fetchedPtoperties;
      }

      DatabaseDataHandler papDataHandler = DatabaseDataHandler();
      papDataHandler.dataStuffing(
        fetchedAppProducts,
        allFetchedAppProductFields,
      );

      Fluttertoast.showToast(msg: 'Suck sus');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  List<AppProduct> _productDataConsolidation(
    List<GetAllProductsQueryProducts> fetchedAppProducts,
  ) {
    List<AppProduct> result = [];
    for (var each in fetchedAppProducts) {
      result.add(
        AppProduct(
          id: each.id,
          name: each.name,
          image: each.imageUrl,
          description: each.description,
        ),
      );
    }
    return result;
  }

  List<AppProductField> _fieldsDataConsolidation(
    List<GetProductFieldsQueryProductFields> productFields,
  ) {
    List<AppProductField> result = [];
    Map<String, String?>? tempAttrinutesMap;

    for (var element in productFields) {
      var temp = element.attributes?.toJson();
      if (temp.toString() == '{attributes: null}' ||
          temp.toString() == '' ||
          temp.toString() == 'null') {
        tempAttrinutesMap = null;
      } else {
        tempAttrinutesMap = temp != {} ? Map<String, String?>.from(temp) : null;
      }
      result.add(
        AppProductField(
          id: element.id,
          productId: element.productId,
          order: element.order,
          fieldName: element.fieldName,
          handler: element.handler,
          attributes: tempAttrinutesMap,
          expectedData: element.expectedData,
        ),
      );
    }
    return result;
  }

  @override
  Future<void> addCurrencies(Currencies currencies) {
    // TODO: implement addCurrencies
    throw UnimplementedError();
  }

  @override
  Future<void> addPriceFunction(PriceFunction priceFunction) {
    // TODO: implement addPriceFunction
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCurrencies(Currencies currencies) {
    // TODO: implement deleteCurrencies
    throw UnimplementedError();
  }

  @override
  Future<void> deletePriceFunction(PriceFunction priceFunction) {
    // TODO: implement deletePriceFunction
    throw UnimplementedError();
  }

  @override
  Future<void> fetchAllCurencies() {
    // TODO: implement fetchAllCurencies
    throw UnimplementedError();
  }

  @override
  Future<void> fetchPriceFunctions(String productId) {
    // TODO: implement fetchPriceFunctions
    throw UnimplementedError();
  }

  @override
  Future<void> fetchProductField(String id) {
    // TODO: implement fetchProductField
    throw UnimplementedError();
  }

  @override
  Future<void> fetchProductFields(String productId) {
    // TODO: implement fetchProductFields
    throw UnimplementedError();
  }
}
