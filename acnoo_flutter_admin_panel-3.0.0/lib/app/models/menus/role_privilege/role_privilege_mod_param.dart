import 'package:json_annotation/json_annotation.dart';
part 'role_privilege_mod_param.g.dart';

@JsonSerializable(includeIfNull: false)
class RolePrivilegeModParam {
  final int? roleId;
  final int privilegeId;
  final int readAuth;
  final int writeAuth;

  RolePrivilegeModParam({
    required this.roleId,
    required this.privilegeId,
    required this.readAuth,
    required this.writeAuth
  });

  factory RolePrivilegeModParam.fromJson(Map<String, dynamic> json) => _$RolePrivilegeModParamFromJson(json);
  Map<String, dynamic> toJson() => _$RolePrivilegeModParamToJson(this);
}