// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModParam _$UserModParamFromJson(Map<String, dynamic> json) => UserModParam(
      json['password'] as String?,
      json['mobile'] as String?,
      json['email'] as String?,
      json['userType'] as String?,
    );

Map<String, dynamic> _$UserModParamToJson(UserModParam instance) =>
    <String, dynamic>{
      'password': instance.password,
      'mobile': instance.mobile,
      'email': instance.email,
      'userType': instance.userType,
    };
