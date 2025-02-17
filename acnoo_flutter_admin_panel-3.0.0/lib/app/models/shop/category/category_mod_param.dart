import 'package:json_annotation/json_annotation.dart';
part 'category_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class CategoryModParam{
  final String? name;
  final String? description;

  CategoryModParam({required this.name, required this.description});

  factory CategoryModParam.fromJson(Map<String, dynamic> json) => _$CategoryModParamFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModParamToJson(this);
}