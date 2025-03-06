import 'package:acnoo_flutter_admin_panel/app/constants/shop/product/product_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ProductModParam {
  final String? name;
  final String? description;
  final String? thumbnail;
  final String? image;
  final String? info;
  final ProductType? type;
  final int? stockQuantity;
  final int? price;
  final int? originPrice;

  ProductModParam({
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

  factory ProductModParam.fromJson(Map<String, dynamic> json) => _$ProductModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModParamToJson(this);
}
