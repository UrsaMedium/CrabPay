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

Map<String, dynamic> atr = {
  "text": "User ID",
  "alignment": "topLeft",
  "color": null,
  "fontSize": null,
  "fontWeight": null,
};

final wraetr = AnyValue(atr);

Map<String, dynamic>? data = {};
final wrdata = AnyValue(data);

Future<void> addProperties() async {
  try {
    final propertiesInserter = await CrabpayConnectorConnector.instance
        .addProductProperty(
          productId: "5bbcb82ecc15438ab758586309c0afc5",
          order: 0,
          handler: 'Text',
          propertyName: 'userIdText',
          attributes: wraetr,
          dataHandler: wrdata,
        )
        .execute();
  } catch (e) {
    print('Failed to fetch $e');
  }
}
