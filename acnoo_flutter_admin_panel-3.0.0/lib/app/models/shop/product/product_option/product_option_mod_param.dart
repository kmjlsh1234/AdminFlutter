import 'package:acnoo_flutter_admin_panel/app/models/shop/product/product_option/product_option_simple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_option_mod_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductOptionModParam{
  final List<ProductOptionSimple> productOptions;

  ProductOptionModParam(this.productOptions);

  factory ProductOptionModParam.fromJson(Map<String, dynamic> json) => _$ProductOptionModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionModParamToJson(this);
}