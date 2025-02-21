import 'package:json_annotation/json_annotation.dart';

part 'product_option_simple_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductOptionSimpleParam {
  final String name;
  final String type;
  final int quantity;

  ProductOptionSimpleParam({
    required this.name,
    required this.type,
    required this.quantity
  });

  factory ProductOptionSimpleParam.fromJson(Map<String, dynamic> json) => _$ProductOptionSimpleParamFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionSimpleParamToJson(this);
}
