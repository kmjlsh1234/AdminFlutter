// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_privilege.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolePrivilege _$RolePrivilegeFromJson(Map<String, dynamic> json) =>
    RolePrivilege(
      privilegeId: (json['privilegeId'] as num).toInt(),
      privilegeName: json['privilegeName'] as String,
      privilegeCode: json['privilegeCode'] as String,
      readAuth: (json['readAuth'] as num).toInt(),
      writeAuth: (json['writeAuth'] as num).toInt(),
    );

Map<String, dynamic> _$RolePrivilegeToJson(RolePrivilege instance) =>
    <String, dynamic>{
      'privilegeId': instance.privilegeId,
      'privilegeName': instance.privilegeName,
      'privilegeCode': instance.privilegeCode,
      'readAuth': instance.readAuth,
      'writeAuth': instance.writeAuth,
    };
