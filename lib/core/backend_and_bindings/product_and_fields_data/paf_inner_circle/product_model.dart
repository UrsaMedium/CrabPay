class AppProduct {
  final String id;
  final String name;
  final String image;
  final String description;

  AppProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory AppProduct.intial() => AppProduct(
    id: '0',
    name: 'name',
    image: 'lib/assets/images/gas-gas-gas.jpg',
    description: 'description',
  );
}
