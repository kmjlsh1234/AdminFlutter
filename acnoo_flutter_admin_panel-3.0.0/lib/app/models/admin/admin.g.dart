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
      loginAt: json['loginAt'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'adminId': instance.adminId,
      'roleId': instance.roleId,
      'status': instance.status,
      'email': instance.email,
      'name': instance.name,
      'mobile': instance.mobile,
      'loginAt': instance.loginAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
