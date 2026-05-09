import 'dart:convert';

import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

List<GetProductPropertiesQueryProductProperties> fetchedAppProductProperties =
    [];

Future<void> productPropertiesFetcher(String productId) async {
  try {
    final fetcher = await CrabpayConnectorConnector.instance
        .getProductPropertiesQuery(productId: productId)
        .execute();
    fetchedAppProductProperties = fetcher.data.productProperties;
  } catch (e) {
    print('Failed to fetch $e');
  }
}

Future<void> addProperties(
  String productId,
  int order,
  String handler,
  String propertyName,
  String attributesAsString,
  String dataHandlerAsString,
) async {
  AnyValue? attributes = AnyValue({}.cast<String, dynamic>());
  AnyValue? dataHandler = AnyValue({}.cast<String, dynamic>());
  if (attributesAsString != 'null') {
    Map<String, dynamic> attributesAsMap = jsonDecode(attributesAsString);
    attributes = AnyValue(attributesAsMap.cast<String, dynamic>());
  }
  if (dataHandlerAsString != 'null') {
    Map<String, dynamic> dataHandlerAsMap = jsonDecode(dataHandlerAsString);
    dataHandler = AnyValue(dataHandlerAsMap.cast<String, dynamic>());
  }
  try {
    await CrabpayConnectorConnector.instance
        .addProductProperty(
          productId: productId,
          order: order,
          handler: handler,
          propertyName: propertyName,
          attributes: attributes,
          dataHandler: dataHandler,
        )
        .execute();
  } catch (e) {
    print('Failed to fetch $e');
  }
}
