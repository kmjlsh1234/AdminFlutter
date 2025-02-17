import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_simple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_option_add_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductOptionAddParam{
  final List<ProductOptionSimple> productOptions;

  ProductOptionAddParam({required this.productOptions});

  factory ProductOptionAddParam.fromJson(Map<String, dynamic> json) => _$ProductOptionAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionAddParamToJson(this);
}