import 'package:json_annotation/json_annotation.dart';
part 'category_mod_param.g.dart';

@JsonSerializable()
class CategoryModParam{
  @JsonKey(includeIfNull: true)
  final String name;
  @JsonKey(includeIfNull: true)
  final String description;

  CategoryModParam(this.name, this.description);

  factory CategoryModParam.fromJson(Map<String, dynamic> json) => _$CategoryModParamFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModParamToJson(this);
}