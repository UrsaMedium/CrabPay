import 'package:crabpay/core/backend/database/general_db/db_inner_circle/data_models/product_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/utilities.dart';

class CrabOrder {
  final String orderId;
  final String orderIdToDisplay;
  final String orderDate;
  final int amountOfDeliveredItems;
  final int amountOfItems;
  final double orderPrice;
  final Map<CartItem, String> itemsToImagesMap;
  final Map<CartItem, Product> itemsToProductMap;
  final List<CartItem> items;

  CrabOrder({
    required this.orderId,
    required this.orderIdToDisplay,
    required this.orderDate,
    required this.amountOfDeliveredItems,
    required this.amountOfItems,
    required this.orderPrice,
    required this.itemsToImagesMap,
    required this.itemsToProductMap,
    required this.items,
  });

  factory CrabOrder.fromOrderEntry({
    required MapEntry<String, List<CartItem>> orderEntry,
    required List<Product> products,
  }) {
    //
    final orderDate = dateConversion(
      orderEntry.value.first.statusChangedAt.toString(),
    );
    //
    Map<CartItem, String> itemsToImages = {};
    Map<CartItem, Product> itemsToProduct = {};
    final uniqueItems = {
      for (var item in orderEntry.value) item.id: item,
    }.values.toList();
    for (var item in uniqueItems) {
      itemsToProduct[item] = products.firstWhere(
        (product) => product.id == item.productId,
      );
      itemsToImages[item] = itemsToProduct[item]?.image ?? 'error';
    }
    //
    final prices = orderEntry.value.map((item) => item.checkoutPrice).toList();
    final total = prices.fold<double>(0, (sum, price) => sum + price);
    //
    final statuses = orderEntry.value.map((item) => item.status).toList();
    int amount = 0;
    for (var status in statuses) {
      if (status == 'delivered') amount++;
    }
    return CrabOrder(
      orderId: orderEntry.key,
      orderIdToDisplay: orderEntry.key.substring(0, 8),
      orderDate: orderDate,
      amountOfDeliveredItems: amount,
      amountOfItems: orderEntry.value.length,
      orderPrice: total,
      itemsToImagesMap: itemsToImages,
      itemsToProductMap: itemsToProduct,
      items: orderEntry.value,
    );
  }
}
