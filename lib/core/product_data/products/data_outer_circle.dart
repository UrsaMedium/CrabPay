import 'package:crabpay/generated/crabpay_connector.dart';

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
