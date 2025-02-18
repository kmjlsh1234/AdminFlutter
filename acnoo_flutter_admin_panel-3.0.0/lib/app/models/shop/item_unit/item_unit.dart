import 'package:json_annotation/json_annotation.dart';

part 'item_unit.g.dart';

@JsonSerializable(includeIfNull: false)
class ItemUnit {
  final int id;
  final String sku;
  final String name;
  final String image;
  final String description;
  final String attributes;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemUnit({
    required this.id,
    required this.sku,
    required this.name,
    required this.image,
    required this.description,
    required this.attributes,
    required this.type,
    required this.createdAt,
    required this.updatedAt
  });

  factory ItemUnit.fromJson(Map<String, dynamic> json) => _$ItemUnitFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitToJson(this);
}
