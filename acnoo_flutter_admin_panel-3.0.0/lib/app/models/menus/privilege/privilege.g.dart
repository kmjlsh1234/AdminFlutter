// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privilege.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Privilege _$PrivilegeFromJson(Map<String, dynamic> json) => Privilege(
      id: (json['id'] as num).toInt(),
      menuId: (json['menuId'] as num?)?.toInt(),
      menuName: json['menuName'] as String?,
      privilegeName: json['privilegeName'] as String,
      privilegeCode: json['privilegeCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PrivilegeToJson(Privilege instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.menuId case final value?) 'menuId': value,
      if (instance.menuName case final value?) 'menuName': value,
      'privilegeName': instance.privilegeName,
      'privilegeCode': instance.privilegeCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
