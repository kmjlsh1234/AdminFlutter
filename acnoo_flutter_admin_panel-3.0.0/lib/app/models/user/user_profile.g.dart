// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      (json['userId'] as num).toInt(),
      json['loginId'] as String,
      json['status'] as String,
      json['mobile'] as String,
      json['email'] as String,
      json['loginType'] as String,
      json['initAt'] == null ? null : DateTime.parse(json['initAt'] as String),
      json['loginAt'] == null
          ? null
          : DateTime.parse(json['loginAt'] as String),
      json['logoutAt'] as String?,
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
      'status': instance.status,
      'mobile': instance.mobile,
      'email': instance.email,
      'loginType': instance.loginType,
      'initAt': instance.initAt?.toIso8601String(),
      'loginAt': instance.loginAt?.toIso8601String(),
      'logoutAt': instance.logoutAt,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nickname': instance.nickname,
      'image': instance.image,
      'basicImageIdx': instance.basicImageIdx,
    };
