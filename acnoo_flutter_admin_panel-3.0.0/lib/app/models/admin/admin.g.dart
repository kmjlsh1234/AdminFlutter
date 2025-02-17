// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) => Admin(
      adminId: (json['adminId'] as num).toInt(),
      roleId: (json['roleId'] as num?)?.toInt(),
      status: json['status'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      loginAt: json['loginAt'] == null
          ? null
          : DateTime.parse(json['loginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'adminId': instance.adminId,
      'roleId': instance.roleId,
      'status': instance.status,
      'email': instance.email,
      'name': instance.name,
      'mobile': instance.mobile,
      'loginAt': instance.loginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
