class PriceFunction {
  final String id;
  final String productId;
  final String functionImageField;
  final String type;
  final Map<List<String>, double> fomulas;
  final String currency;

  PriceFunction({
    required this.id,
    required this.productId,
    required this.functionImageField,
    required this.type,
    required this.fomulas,
    required this.currency,
  });

  factory PriceFunction.intial() => PriceFunction(
    id: '',
    productId: '',
    functionImageField: '',
    type: '',
    fomulas: {},
    currency: '',
  );
}
