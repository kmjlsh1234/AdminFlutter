// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModParam _$RoleModParamFromJson(Map<String, dynamic> json) => RoleModParam(
      roleName: json['roleName'] as String?,
      description: json['description'] as String?,
      rolePrivileges: (json['rolePrivileges'] as List<dynamic>)
          .map((e) => RolePrivilegeModParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoleModParamToJson(RoleModParam instance) =>
    <String, dynamic>{
      'roleName': instance.roleName,
      'description': instance.description,
      'rolePrivileges': instance.rolePrivileges,
    };
