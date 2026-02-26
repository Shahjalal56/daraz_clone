import '../../domain/entity/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        description: json['description'],
        category: json['category'],
        image: json['image'],
        ratingRate: (json['rating']['rate'] as num).toDouble(),
        ratingCount: json['rating']['count'],
      );

  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        ratingRate: ratingRate,
        ratingCount: ratingCount,
      );
}
