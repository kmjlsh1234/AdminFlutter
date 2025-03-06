// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privilege_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivilegeModParam _$PrivilegeModParamFromJson(Map<String, dynamic> json) =>
    PrivilegeModParam(
      privilegeName: json['privilegeName'] as String?,
      privilegeCode: json['privilegeCode'] as String?,
      menuId: (json['menuId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PrivilegeModParamToJson(PrivilegeModParam instance) =>
    <String, dynamic>{
      'privilegeName': instance.privilegeName,
      'privilegeCode': instance.privilegeCode,
      'menuId': instance.menuId,
    };
