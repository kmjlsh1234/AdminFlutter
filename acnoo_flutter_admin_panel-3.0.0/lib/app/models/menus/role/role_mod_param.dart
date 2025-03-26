import 'package:acnoo_flutter_admin_panel/app/models/menus/role_privilege/role_privilege_mod_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'role_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class RoleModParam{
  final String? roleName;
  final String? description;
  final List<RolePrivilegeModParam> rolePrivileges;
  RoleModParam({
    required this.roleName,
    required this.description,
    required this.rolePrivileges
  });

  factory RoleModParam.fromJson(Map<String, dynamic> json) => _$RoleModParamFromJson(json);
  Map<String, dynamic> toJson() => _$RoleModParamToJson(this);
}