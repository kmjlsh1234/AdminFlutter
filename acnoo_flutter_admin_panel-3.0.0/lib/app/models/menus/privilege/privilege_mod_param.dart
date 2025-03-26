import 'package:json_annotation/json_annotation.dart';
part 'privilege_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class PrivilegeModParam{
  final String? privilegeName;
  final String? privilegeCode;
  final int? menuId;

  PrivilegeModParam({
    required this.privilegeName,
    required this.privilegeCode,
    required this.menuId
  });

  factory PrivilegeModParam.fromJson(Map<String, dynamic> json) => _$PrivilegeModParamFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeModParamToJson(this);
}