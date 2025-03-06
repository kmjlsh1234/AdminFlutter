// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_privilege_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolePrivilegeAddParam _$RolePrivilegeAddParamFromJson(
        Map<String, dynamic> json) =>
    RolePrivilegeAddParam(
      roleId: (json['roleId'] as num?)?.toInt(),
      privilegeId: (json['privilegeId'] as num).toInt(),
      readAuth: (json['readAuth'] as num).toInt(),
      writeAuth: (json['writeAuth'] as num).toInt(),
    );

Map<String, dynamic> _$RolePrivilegeAddParamToJson(
        RolePrivilegeAddParam instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'privilegeId': instance.privilegeId,
      'readAuth': instance.readAuth,
      'writeAuth': instance.writeAuth,
    };
