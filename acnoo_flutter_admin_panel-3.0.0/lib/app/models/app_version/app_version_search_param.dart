import 'package:json_annotation/json_annotation.dart';
part 'app_version_search_param.g.dart';

@JsonSerializable()
class AppVersionSearchParam{
  @JsonKey(includeIfNull: true)
  final String? versionType;
  @JsonKey(includeIfNull: true)
  final String? sortType;
  @JsonKey(includeIfNull: true)
  final String? orderBy;

  AppVersionSearchParam(this.versionType, this.sortType, this.orderBy);
  factory AppVersionSearchParam.fromJson(Map<String, dynamic> json) => _$AppVersionSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionSearchParamToJson(this);
}