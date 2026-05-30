class Product {
  final String id;
  final String name;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Product.intial() => Product(
    id: '0',
    name: 'name',
    image: 'lib/assets/images/gas-gas-gas.jpg',
    description: 'description',
  );
}
