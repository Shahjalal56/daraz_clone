class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });
}
