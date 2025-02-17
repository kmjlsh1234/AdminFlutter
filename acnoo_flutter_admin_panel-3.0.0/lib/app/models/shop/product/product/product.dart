import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable(includeIfNull: true)
class Product {
  final int id;
  final String name;
  final String description;
  final String status;
  final String thumbnail;
  final String image;
  final String info;
  final String type;
  final int? stockQuantity;
  final int price;
  final int originPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.thumbnail,
    required this.image,
    required this.info,
    required this.type,
    required this.stockQuantity,
    required this.price,
    required this.originPrice,
    required this.createdAt,
    required this.updatedAt}
  );

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
