import 'package:json_annotation/json_annotation.dart';

part 'item_unit_add_param.g.dart';

@JsonSerializable()
class ItemUnitAddParam{
  final String sku;
  final String name;
  final String image;
  final String description;
  final String attributes;
  final String type;

  ItemUnitAddParam(this.sku, this.name, this.image, this.description, this.attributes, this.type);

  factory ItemUnitAddParam.fromJson(Map<String, dynamic> json) => _$ItemUnitAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitAddParamToJson(this);
}