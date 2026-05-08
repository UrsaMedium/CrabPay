import 'package:crabpay/generated/crabpay_connector.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

List<GetAllProductsQueryProducts> fetchedAppProducts = [];

Future<void> productDataOuterCircleFetcher() async {
  try {
    final fetrcher = await CrabpayConnectorConnector.instance
        .getAllProductsQuery()
        .execute();
    fetchedAppProducts = fetrcher.data.products;
  } catch (e) {
    print('Failed to fetch $e');
  }
}


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