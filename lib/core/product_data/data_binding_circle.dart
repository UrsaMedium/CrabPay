import 'package:crabpay/core/product_data/data_outer_circle.dart';
import 'package:crabpay/core/product_data/product_model.dart';

final List<AppProduct> appProducts = [];

void dataConsolidation() {
  for (var element in fetchedAppProducts) {
    appProducts.add(
      AppProduct(
        id: element.id,
        name: element.name,
        image: element.imageUrl!,
        description: element.description!,
        price: element.price,
      ),
    );
  }
}
