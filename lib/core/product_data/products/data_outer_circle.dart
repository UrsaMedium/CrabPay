import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<GetAllProductsQueryProducts> fetchedAppProducts = [];

Future<void> productDataOuterCircleFetcher() async {
  try {
    final fetrcher = await CrabpayConnectorConnector.instance
        .getAllProductsQuery()
        .execute();
    fetchedAppProducts = fetrcher.data.products;
    Fluttertoast.showToast(msg: 'Suck sus');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Failed to fetch $e');
  }
}

late OperationResult<AddProductData, AddProductVariables> productInserter;
Future<void> addProductWithProperties() async {
  try {
    await CrabpayConnectorConnector.instance
        .addProduct(
          description: 'description',
          imageUrl: 'lib/assets/images/gas-gas-gas.jpg',
          name: 'Gas',
          price: 123,
        )
        .execute();

    Fluttertoast.showToast(msg: 'Suck sus');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Failed to fetch $e');
  }
}
