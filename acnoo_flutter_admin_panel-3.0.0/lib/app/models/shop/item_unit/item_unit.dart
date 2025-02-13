import 'package:json_annotation/json_annotation.dart';

part 'item_unit.g.dart';

@JsonSerializable()
class ItemUnit{
  final int id;
  final String sku;
  final String name;
  final String image;
  final String description;
  final String attributes;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemUnit(this.id, this.sku, this.name, this.image, this.description, this.attributes, this.type, this.createdAt, this.updatedAt);

  factory ItemUnit.fromJson(Map<String, dynamic> json) => _$ItemUnitFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitToJson(this);
}