// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleAddParam _$RoleAddParamFromJson(Map<String, dynamic> json) => RoleAddParam(
      roleName: json['roleName'] as String,
      description: json['description'] as String,
      rolePrivileges: (json['rolePrivileges'] as List<dynamic>)
          .map((e) => RolePrivilegeAddParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoleAddParamToJson(RoleAddParam instance) =>
    <String, dynamic>{
      'roleName': instance.roleName,
      'description': instance.description,
      'rolePrivileges': instance.rolePrivileges,
    };
