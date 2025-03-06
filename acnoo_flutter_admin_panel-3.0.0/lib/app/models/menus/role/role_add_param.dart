import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege_add_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'role_add_param.g.dart';

@JsonSerializable(includeIfNull: false)
class RoleAddParam{
  final String roleName;
  final String description;
  final List<RolePrivilegeAddParam> rolePrivileges;

  RoleAddParam({
    required this.roleName,
    required this.description,
    required this.rolePrivileges,
  });

  factory RoleAddParam.fromJson(Map<String, dynamic> json) => _$RoleAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$RoleAddParamToJson(this);
}