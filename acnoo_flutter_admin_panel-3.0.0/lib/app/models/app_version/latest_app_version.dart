import 'package:json_annotation/json_annotation.dart';
part 'latest_app_version.g.dart';

@JsonSerializable()
class LatestAppVersion{
  @JsonKey(includeIfNull: true)
  final String? forceUpdateVersion;
  @JsonKey(includeIfNull: true)
  final String? induceUpdateVersion;
  @JsonKey(includeIfNull: true)
  final String? bundleUpdateVersion;

  LatestAppVersion({this.forceUpdateVersion, this.induceUpdateVersion, this.bundleUpdateVersion});
  factory LatestAppVersion.fromJson(Map<String, dynamic> json) => _$LatestAppVersionFromJson(json);
  Map<String, dynamic> toJson() => _$LatestAppVersionToJson(this);
}