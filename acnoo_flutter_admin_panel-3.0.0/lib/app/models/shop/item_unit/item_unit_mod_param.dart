import 'package:json_annotation/json_annotation.dart';

part 'item_unit_mod_param.g.dart';

@JsonSerializable()
class ItemUnitModParam{
  @JsonKey(includeIfNull: true)
  final String? sku;
  @JsonKey(includeIfNull: true)
  final String? name;
  @JsonKey(includeIfNull: true)
  final String? image;
  @JsonKey(includeIfNull: true)
  final String? description;
  @JsonKey(includeIfNull: true)
  final String? attributes;
  @JsonKey(includeIfNull: true)
  final String? type;

  ItemUnitModParam(this.sku, this.name, this.image, this.description, this.attributes, this.type);

  factory ItemUnitModParam.fromJson(Map<String, dynamic> json) => _$ItemUnitModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitModParamToJson(this);
}