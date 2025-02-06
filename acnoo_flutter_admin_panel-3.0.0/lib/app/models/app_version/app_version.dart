import 'package:json_annotation/json_annotation.dart';
part 'app_version.g.dart';

@JsonSerializable()
class AppVersion{
  final int id;
  final String version;
  final String versionType;
  final String publishAt;
  final String publishStatus;
  final String createdAt;
  final String updatedAt;

  AppVersion(this.id, this.version, this.versionType, this.publishAt, this.publishStatus, this.createdAt, this.updatedAt);
  factory AppVersion.fromJson(Map<String, dynamic> json) => _$AppVersionFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}