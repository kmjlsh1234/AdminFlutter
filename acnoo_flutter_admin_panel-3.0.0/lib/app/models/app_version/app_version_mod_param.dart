import 'package:acnoo_flutter_admin_panel/app/constants/app_version/publish_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_version_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class AppVersionModParam {
  final String? publishAt;
  final PublishStatus? publishStatus;

  AppVersionModParam({required this.publishAt, required this.publishStatus});

  factory AppVersionModParam.fromJson(Map<String, dynamic> json) => _$AppVersionModParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionModParamToJson(this);
}
