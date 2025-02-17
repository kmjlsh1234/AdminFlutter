import 'package:json_annotation/json_annotation.dart';

part 'product_option_simple.g.dart';

@JsonSerializable(includeIfNull: false)
class ProductOptionSimple {
  final String name;
  final String type;
  final int quantity;

  ProductOptionSimple({
    required this.name,
    required this.type,
    required this.quantity
  });

  factory ProductOptionSimple.fromJson(Map<String, dynamic> json) => _$ProductOptionSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionSimpleToJson(this);
}
