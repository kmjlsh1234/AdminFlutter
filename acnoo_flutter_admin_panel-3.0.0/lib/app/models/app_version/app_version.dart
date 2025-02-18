import 'package:json_annotation/json_annotation.dart';

part 'app_version.g.dart';

@JsonSerializable(includeIfNull: false)
class AppVersion {
  final int id;
  final String version;
  final String versionType;
  final String publishAt;
  final String publishStatus;
  final String createdAt;
  final String updatedAt;

  AppVersion({
    required this.id,
    required this.version,
    required this.versionType,
    required this.publishAt,
    required this.publishStatus,
    required this.createdAt,
    required this.updatedAt
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) => _$AppVersionFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
