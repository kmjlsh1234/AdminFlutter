import 'package:json_annotation/json_annotation.dart';
part 'app_version_mod_param.g.dart';

@JsonSerializable()
class AppVersionModParam{
  @JsonKey(includeIfNull: true)
  final String? publishAt;

  @JsonKey(includeIfNull: true)
  final String? publishStatus;

  AppVersionModParam(this.publishAt, this.publishStatus);
  factory AppVersionModParam.fromJson(Map<String, dynamic> json) => _$AppVersionModParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionModParamToJson(this);
}