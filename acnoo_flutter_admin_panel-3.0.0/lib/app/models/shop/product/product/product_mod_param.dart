import 'package:json_annotation/json_annotation.dart';
part 'product_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ProductModParam{
  final String? name;
  final String? description;
  final String? thumbnail;
  final String? image;
  final String? info;
  final String? type;
  final int? stockQuantity;
  final int? price;
  final int? originPrice;

  ProductModParam(
      this.name,
      this.description,
      this.thumbnail,
      this.image,
      this.info,
      this.type,
      this.stockQuantity,
      this.price,
      this.originPrice
  );


  factory ProductModParam.fromJson(Map<String, dynamic> json) => _$ProductModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModParamToJson(this);
}