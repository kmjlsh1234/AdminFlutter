// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_join_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJoinParam _$AdminJoinParamFromJson(Map<String, dynamic> json) =>
    AdminJoinParam(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
    );

Map<String, dynamic> _$AdminJoinParamToJson(AdminJoinParam instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'mobile': instance.mobile,
    };
