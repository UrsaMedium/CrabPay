class Product {
  final String id;
  final String name;
  final String image;
  final String description;
  final String currencies;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.currencies,
    required this.category,
  });

  factory Product.intial() => Product(
    id: '',
    name: '',
    image: '',
    description: '',
    currencies: '',
    category: '',
  );
}
