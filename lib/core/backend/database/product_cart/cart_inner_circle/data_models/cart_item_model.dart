class CartItem {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String productName;
  final Map<String, String> purchaseData; // field : data from the field
  final String currency;
  final double checkoutPrice;
  final String status;
  final String? comment;
  final String? paymentId;

  CartItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.purchaseData,
    required this.currency,
    required this.checkoutPrice,
    required this.status,
    this.comment,
    this.paymentId
  });

  factory CartItem.intial() => CartItem(
    id: '',
    userId: '',
    userName: '',
    productId: '',
    productName: '',
    purchaseData: {},
    currency: '',
    checkoutPrice: 0,
    status: '',
  );
}
