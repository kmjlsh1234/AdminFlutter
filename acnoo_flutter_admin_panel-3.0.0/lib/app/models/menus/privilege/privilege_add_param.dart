import 'package:json_annotation/json_annotation.dart';
part 'privilege_add_param.g.dart';

@JsonSerializable(includeIfNull: true)
class PrivilegeAddParam{
  final String privilegeName;
  final String privilegeCode;
  final int? menuId;

  PrivilegeAddParam({
    required this.privilegeName,
    required this.privilegeCode,
    required this.menuId
  });

  factory PrivilegeAddParam.fromJson(Map<String, dynamic> json) => _$PrivilegeAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeAddParamToJson(this);
}