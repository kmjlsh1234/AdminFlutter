import 'package:json_annotation/json_annotation.dart';
part 'product_add_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ProductAddParam{
  final String name;
  final String description;
  final String thumbnail;
  final String image;
  final String info;
  final String type;
  final int? stockQuantity;
  final int price;
  final int originPrice;

  ProductAddParam({
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.image,
    required this.info,
    required this.type,
    required this.stockQuantity,
    required this.price,
    required this.originPrice
  });

  factory ProductAddParam.fromJson(Map<String, dynamic> json) => _$ProductAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAddParamToJson(this);
}