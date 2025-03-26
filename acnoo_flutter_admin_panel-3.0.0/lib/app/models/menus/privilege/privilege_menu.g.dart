// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privilege_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivilegeMenu _$PrivilegeMenuFromJson(Map<String, dynamic> json) =>
    PrivilegeMenu(
      menuId: (json['menuId'] as num).toInt(),
      parentId: (json['parentId'] as num?)?.toInt(),
      menuName: json['menuName'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      menuPath: json['menuPath'] as String,
      privilegeId: (json['privilegeId'] as num).toInt(),
      privilegeName: json['privilegeName'] as String,
      privilegeCode: json['privilegeCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PrivilegeMenuToJson(PrivilegeMenu instance) =>
    <String, dynamic>{
      'menuId': instance.menuId,
      'parentId': instance.parentId,
      'menuName': instance.menuName,
      'sortOrder': instance.sortOrder,
      'menuPath': instance.menuPath,
      'privilegeId': instance.privilegeId,
      'privilegeName': instance.privilegeName,
      'privilegeCode': instance.privilegeCode,
      'createdAt': instance.createdAt.toIso8601String(),
    };
