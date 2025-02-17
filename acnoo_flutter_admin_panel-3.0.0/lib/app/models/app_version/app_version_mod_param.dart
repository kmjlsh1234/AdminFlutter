import 'package:json_annotation/json_annotation.dart';

part 'app_version_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class AppVersionModParam {
  final String? publishAt;
  final String? publishStatus;

  AppVersionModParam(this.publishAt, this.publishStatus);

  factory AppVersionModParam.fromJson(Map<String, dynamic> json) => _$AppVersionModParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionModParamToJson(this);
}
