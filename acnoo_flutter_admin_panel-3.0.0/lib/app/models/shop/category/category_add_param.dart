import 'package:json_annotation/json_annotation.dart';
part 'category_add_param.g.dart';

@JsonSerializable()
class CategoryAddParam{
  final String name;
  final String description;

  CategoryAddParam(this.name, this.description);

  factory CategoryAddParam.fromJson(Map<String, dynamic> json) => _$CategoryAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryAddParamToJson(this);
}