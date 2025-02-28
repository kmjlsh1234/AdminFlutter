import 'package:json_annotation/json_annotation.dart';
part 'app_version_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class AppVersionSearchParam{
  final String? versionType;

  AppVersionSearchParam({
    required this.versionType
});
  factory AppVersionSearchParam.fromJson(Map<String, dynamic> json) => _$AppVersionSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionSearchParamToJson(this);
}