import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/product_properties_model.dart';
import 'package:crabpay/core/backend_and_bindings/product_data/product_properties/properties_data_inner_circle_service.dart';
import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseDataConnectProductPropertyHandler
    implements AppProductPropertyHandler {
  List<AppProductProperty> _propertiesDataConsolidation(
    List<GetProductPropertiesQueryProductProperties>
    fetchedAppProductProperties,
  ) {
    List<AppProductProperty> result = [];
    Map<String, String?>? tempAttrinutesMap;
    Map<String, String>? tempDataHandlerMap;
    for (var element in fetchedAppProductProperties) {
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

  @override
  Future<void> addProductProperty(AppProductProperty productProperty) async {
    try {
      await CrabpayConnectorConnector.instance
          .addProductProperty(
            productId: productProperty.productId,
            order: productProperty.order,
            handler: productProperty.handler,
            propertyName: productProperty.propertyName,
            attributes: productProperty.attributes,
            dataHandler: productProperty.dataHandler,
          )
          .execute();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<void> deleteProductProperty(AppProductProperty productProperty) async {
    try {
      CrabpayConnectorConnector.instance.deleteProductProperty(
        id: productProperty.id,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
    }
  }

  @override
  Future<List<AppProductProperty>> productPropertiesOfProduct(
    String productId,
  ) async {
    try {
      final fetcher = await CrabpayConnectorConnector.instance
          .getProductPropertiesQuery(productId: productId)
          .execute();
      return _propertiesDataConsolidation(fetcher.data.productProperties);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch $e');
      rethrow;
    }
  }
}
