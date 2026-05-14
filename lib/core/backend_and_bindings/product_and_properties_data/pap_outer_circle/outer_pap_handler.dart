import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/inner_pap_handler.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/pap_inner_circle/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_and_properties_data/product_controller.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OuterProductAndPropertiesHandler
    implements InnerProductAndPropertiesHandler {
  @override
  Future<void> addProduct(AppProduct product) async {
    try {
      await CrabpayConnectorConnector.instance
          .addProduct(
            description: product.description,
            imageUrl: product.image,
            name: product.name,
            price: product.price,
          )
          .execute();
      fetchAllPAPData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> addProductProperty(AppProductProperty property) async {
    try {
      AnyValue? attributes;
      if (property.attributes != null) {
        attributes = AnyValue(property.attributes!.cast<String, dynamic>());
      }
      AnyValue? dataHandler;
      if (property.dataHandler != null) {
        dataHandler = AnyValue(property.dataHandler!.cast<String, dynamic>());
      }
      await CrabpayConnectorConnector.instance
          .addProductProperty(
            productId: property.productId,
            order: property.order,
            attributes: attributes,
            dataHandler: dataHandler,
            handler: property.handler,
            propertyName: property.propertyName,
          )
          .execute();
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
  Future<void> deleteProductProperty(AppProductProperty property) async {
    await CrabpayConnectorConnector.instance
        .deleteProductProperty(id: property.id)
        .execute();
  }

  @override
  Future<void> fetchAllPAPData() async {
    try {
      final productFetrcher = await CrabpayConnectorConnector.instance
          .getAllProductsQuery()
          .execute();
      final fetchedAppProducts = _productDataConsolidation(
        productFetrcher.data.products,
      );

      Map<String, List<AppProductProperty>> allFetchedAppProductProperties = {};
      for (var each in fetchedAppProducts) {
        final propertyFetcher = await CrabpayConnectorConnector.instance
            .getProductPropertiesQuery(productId: each.id)
            .execute();
        final fetchedPtoperties = _propertiesDataConsolidation(
          propertyFetcher.data.productProperties,
        );
        allFetchedAppProductProperties[each.id] = fetchedPtoperties;
      }

      PAPDataHandler papDataHandler = PAPDataHandler();
      papDataHandler.dataStuffing(
        fetchedAppProducts,
        allFetchedAppProductProperties,
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
          price: each.price,
        ),
      );
    }
    return result;
  }

  List<AppProductProperty> _propertiesDataConsolidation(
    List<GetProductPropertiesQueryProductProperties> productProperties,
  ) {
    List<AppProductProperty> result = [];
    Map<String, String?>? tempAttrinutesMap;
    Map<String, String>? tempDataHandlerMap;
    for (var element in productProperties) {
      tempAttrinutesMap = element.attributes as Map<String, String?>?;
      tempDataHandlerMap = element.dataHandler as Map<String, String>?;
      result.add(
        AppProductProperty(
          id: element.id,
          productId: element.productId,
          order: element.order,
          propertyName: element.propertyName,
          handler: element.handler,
          attributes: tempAttrinutesMap,
          dataHandler: tempDataHandlerMap,
        ),
      );
    }
    return result;
  }
}