import 'package:json_annotation/json_annotation.dart';

import '../../../../constants/shop/product/product_status.dart';
import '../../../../constants/shop/product/product_type.dart';
part 'product.g.dart';

@JsonSerializable(includeIfNull: true)
class Product {
  final int id;
  final String name;
  final String description;
  final ProductStatus status;
  final String thumbnail;
  final String image;
  final String info;
  final ProductType type;
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
