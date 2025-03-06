// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_privilege_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolePrivilegeModParam _$RolePrivilegeModParamFromJson(
        Map<String, dynamic> json) =>
    RolePrivilegeModParam(
      roleId: (json['roleId'] as num?)?.toInt(),
      privilegeId: (json['privilegeId'] as num).toInt(),
      readAuth: (json['readAuth'] as num).toInt(),
      writeAuth: (json['writeAuth'] as num).toInt(),
    );

Map<String, dynamic> _$RolePrivilegeModParamToJson(
        RolePrivilegeModParam instance) =>
    <String, dynamic>{
      if (instance.roleId case final value?) 'roleId': value,
      'privilegeId': instance.privilegeId,
      'readAuth': instance.readAuth,
      'writeAuth': instance.writeAuth,
    };
