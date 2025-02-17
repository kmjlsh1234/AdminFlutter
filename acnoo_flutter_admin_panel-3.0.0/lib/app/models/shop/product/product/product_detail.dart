import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_detail.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductDetail {
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
  final List<ProductOption> options;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetail(
      {required this.id,
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
      required this.options,
      required this.createdAt,
      required this.updatedAt});

  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}
