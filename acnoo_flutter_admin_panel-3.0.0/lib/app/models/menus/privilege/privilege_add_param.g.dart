// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privilege_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivilegeAddParam _$PrivilegeAddParamFromJson(Map<String, dynamic> json) =>
    PrivilegeAddParam(
      privilegeName: json['privilegeName'] as String,
      privilegeCode: json['privilegeCode'] as String,
      menuId: (json['menuId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PrivilegeAddParamToJson(PrivilegeAddParam instance) =>
    <String, dynamic>{
      'privilegeName': instance.privilegeName,
      'privilegeCode': instance.privilegeCode,
      'menuId': instance.menuId,
    };
