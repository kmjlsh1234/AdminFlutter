import 'package:json_annotation/json_annotation.dart';
part 'role_privilege.g.dart';

@JsonSerializable(includeIfNull: false)
class RolePrivilege{
  final int privilegeId;        // 권한고유번호
  final String privilegeName;       // 권한이름
  final String privilegeCode;       // 권한코드
  int readAuth;           // 읽기권한 여부 DEFAULT 1 있음
  int writeAuth;          // 쓰기권한 여부 DEFAULT 0 없음

  RolePrivilege({
    required this.privilegeId,
    required this.privilegeName,
    required this.privilegeCode,
    required this.readAuth,
    required this.writeAuth
  });

  factory RolePrivilege.fromJson(Map<String, dynamic> json) => _$RolePrivilegeFromJson(json);
  Map<String, dynamic> toJson() => _$RolePrivilegeToJson(this);
}