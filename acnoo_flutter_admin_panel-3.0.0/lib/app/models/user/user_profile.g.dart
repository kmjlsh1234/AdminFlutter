// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      (json['userId'] as num).toInt(),
      json['loginId'] as String,
      $enumDecode(_$UserStatusEnumMap, json['status']),
      json['mobile'] as String,
      json['email'] as String,
      $enumDecode(_$LoginTypeEnumMap, json['loginType']),
      json['initAt'] == null ? null : DateTime.parse(json['initAt'] as String),
      json['loginAt'] == null
          ? null
          : DateTime.parse(json['loginAt'] as String),
      json['logoutAt'] == null
          ? null
          : DateTime.parse(json['logoutAt'] as String),
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
      json['nickname'] as String,
      json['image'] as String?,
      (json['basicImageIdx'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'loginId': instance.loginId,
      'status': _$UserStatusEnumMap[instance.status]!,
      'mobile': instance.mobile,
      'email': instance.email,
      'loginType': _$LoginTypeEnumMap[instance.loginType]!,
      'initAt': instance.initAt?.toIso8601String(),
      'loginAt': instance.loginAt?.toIso8601String(),
      'logoutAt': instance.logoutAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nickname': instance.nickname,
      'image': instance.image,
      'basicImageIdx': instance.basicImageIdx,
    };

const _$UserStatusEnumMap = {
  UserStatus.NORMAL: 'NORMAL',
  UserStatus.LOGOUT: 'LOGOUT',
  UserStatus.STOP: 'STOP',
  UserStatus.BAN: 'BAN',
  UserStatus.TRY_EXIT: 'TRY_EXIT',
  UserStatus.EXIT: 'EXIT',
};

const _$LoginTypeEnumMap = {
  LoginType.EMAIL: 'EMAIL',
  LoginType.MOBILE: 'MOBILE',
  LoginType.SOCIAL: 'SOCIAL',
  LoginType.ID_PASS: 'ID_PASS',
  LoginType.GUEST: 'GUEST',
};
