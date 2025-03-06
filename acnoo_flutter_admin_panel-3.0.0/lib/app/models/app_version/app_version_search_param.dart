import 'package:acnoo_flutter_admin_panel/app/constants/app_version/app_version_type.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app_version_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class AppVersionSearchParam{
  final AppVersionType? versionType;

  AppVersionSearchParam({
    required this.versionType
});
  factory AppVersionSearchParam.fromJson(Map<String, dynamic> json) => _$AppVersionSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$AppVersionSearchParamToJson(this);
}