class PriceFunction {
  final String id;
  final String productId;
  final String name;
  final String type;
  final Map<List<String>, double> fomulas;
  final String currency;

  PriceFunction({
    required this.id,
    required this.productId,
    required this.name,
    required this.type,
    required this.fomulas,
    required this.currency,
  });

  factory PriceFunction.intial() => PriceFunction(
    id: '',
    productId: '',
    name: '',
    type: '',
    fomulas: {},
    currency: '',
  );
}
