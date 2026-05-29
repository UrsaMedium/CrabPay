class Currencies {
  final String id;
  final String name;
  final String mainCurrency;
  final double rub;
  final double usd;

  Currencies({
    required this.id,
    required this.name,
    required this.mainCurrency,
    required this.rub,
    required this.usd,
  });

  factory Currencies.intial() =>
      Currencies(id: '', name: '', mainCurrency: '', rub: 0, usd: 0);
}
