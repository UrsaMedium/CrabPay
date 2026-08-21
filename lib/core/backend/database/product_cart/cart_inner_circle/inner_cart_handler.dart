import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/common/paginated_result_data_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/cart_item_model.dart';
import 'package:crabpay/core/backend/database/product_cart/cart_inner_circle/data_models/pending_order_model.dart';

abstract class InnerCartHandler {
  Future<List<CartItem>> fetchCartItemsToBuy(String userId);
  // Future<List<CartItem>> fetchCartItemsOnPyamentState(String userId);
  Future<List<CartItem>> fetchPendingCartItems(String paymentId);
  Future<PaginatedResult<String>> fetchNotDeliveredOrdersIds(
    String userId, {
    String? pageToken,
  });
  Future<PaginatedResult<String>> fetchDeliveredOrdersIds(
    String userId, {
    String? pageToken,
  });
  Future<PaginatedResult<String>> fetchSearchedOrdersIds({
    required String userId,
    String? pageToken,
    DateTime? fromDate,
    DateTime? toDate,
    String? orderId,
  });
  Future<List<CartItem>> fetchItemsOfOrder(String userId, String orderId);
  Stream<int> streamUserCartItemAmount(String userId);
  Future<void> addCartItem(CartItem cartItem);
  Future<void> deleteCartItem(String cartItemId);
  Future<void> updateCartItem(List<CartItem> cartItems, AppAuthUser? user);
  Future<int> getProductCartItemAmount(String userId, String productId);
  Future<bool> deleteLastAddedProductCartItem(String userId, String productId);
  //on payment items
  Stream<List<PendingOrder>> streamPendingOrders(String userId);
}
