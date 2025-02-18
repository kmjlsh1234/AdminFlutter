import 'package:json_annotation/json_annotation.dart';

part 'item_unit_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemUnitModParam{
  final String? sku;
  final String? name;
  final String? image;
  final String? description;
  final String? attributes;
  final String? type;

  ItemUnitModParam(this.sku, this.name, this.image, this.description, this.attributes, this.type);

  factory ItemUnitModParam.fromJson(Map<String, dynamic> json) => _$ItemUnitModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitModParamToJson(this);
}