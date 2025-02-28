import 'package:json_annotation/json_annotation.dart';

part 'app_version_add_param.g.dart';

@JsonSerializable(includeIfNull: false)
class AppVersionAddParam {
  final String version;
  final String versionType;
  final String? publishAt;
  final String publishStatus;

  AppVersionAddParam({
    required this.version,
    required this.versionType,
    required this.publishAt,
    required this.publishStatus
  });

  factory AppVersionAddParam.fromJson(Map<String, dynamic> json) => _$AppVersionAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionAddParamToJson(this);
}
