// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModParam _$AdminModParamFromJson(Map<String, dynamic> json) =>
    AdminModParam(
      roleId: (json['roleId'] as num?)?.toInt(),
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
    );

Map<String, dynamic> _$AdminModParamToJson(AdminModParam instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'mobile': instance.mobile,
    };
