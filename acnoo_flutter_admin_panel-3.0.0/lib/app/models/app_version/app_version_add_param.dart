import 'package:acnoo_flutter_admin_panel/app/constants/app_version/publish_status.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/app_version/app_version_type.dart';

part 'app_version_add_param.g.dart';

@JsonSerializable(includeIfNull: false)
class AppVersionAddParam {
  final String version;
  final AppVersionType versionType;
  final String? publishAt;
  final PublishStatus publishStatus;

  AppVersionAddParam({
    required this.version,
    required this.versionType,
    required this.publishAt,
    required this.publishStatus
  });

  factory AppVersionAddParam.fromJson(Map<String, dynamic> json) => _$AppVersionAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionAddParamToJson(this);
}
