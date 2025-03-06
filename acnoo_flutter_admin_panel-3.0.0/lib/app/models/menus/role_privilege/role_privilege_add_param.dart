import 'package:json_annotation/json_annotation.dart';
part 'role_privilege_add_param.g.dart';

@JsonSerializable(includeIfNull: true)
class RolePrivilegeAddParam {
  final int? roleId;
  final int privilegeId;
  final int readAuth;
  final int writeAuth;

  RolePrivilegeAddParam({
    required this.roleId,
    required this.privilegeId,
    required this.readAuth,
    required this.writeAuth
  });

  factory RolePrivilegeAddParam.fromJson(Map<String, dynamic> json) => _$RolePrivilegeAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$RolePrivilegeAddParamToJson(this);
}