import 'package:crabpay/core/product_data/product_model.dart';

class AppProductController {
  AppProduct findById(String? id) {
    return _products.firstWhere((product) => product.id == id);
  }

  List<AppProduct> get products => _products;

  final List<AppProduct> _products = [
    AppProduct(
      id: '1',
      name: 'PUBG',
      image: 'lib/assets/images/pubg.webp ',
      description: 'description',
      price: 123,
    ),
  ];
}
