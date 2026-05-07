import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

late OperationResult<AddProductData, AddProductVariables> productInserter;


Future<void> addProductWithProperties() async {
  try {
    final productInserter = await CrabpayConnectorConnector.instance
        .addProduct(
          description: 'description',
          imageUrl: 'lib/assets/images/gas-gas-gas.jpg',
          name: 'Gas',
          price: 123,
        )
        .execute();
  } catch (e) {
    print('Failed to fetch $e');
  }
}

Future<void> addProperties() async {
  try {
    final propertiesInserter = await CrabpayConnectorConnector.instance
        .addProductPropertiesToProduct(
          productId: productInserter.data.product_insert.id,
          handler: 'Text',
          propertyName: 'userIdText',
          attributes: {
            "text": "User ID",
            "alignment": "topLeft",
            "color": null,
            "fontSize": null,
            "fontWeight": null,
          },
          dataHandler: null,
        )
        .execute();
  } catch (e) {
    print('Failed to fetch $e');
  }
}
