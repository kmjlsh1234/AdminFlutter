import 'package:acnoo_flutter_admin_panel/app/constants/shop/product/product_option_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_option.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductOption{
  final int id;
  final int productId;
  final String name;
  final ProductOptionType type;
  final int quantity;
  final DateTime createdAt;

  ProductOption({
    required this.id,
    required this.productId,
    required this.name,
    required this.type,
    required this.quantity,
    required this.createdAt
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => _$ProductOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionToJson(this);
}