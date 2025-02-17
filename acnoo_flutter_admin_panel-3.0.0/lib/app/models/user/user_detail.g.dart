// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
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
      json['logoutAt'] == null
          ? null
          : DateTime.parse(json['logoutAt'] as String),
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
      json['nickname'] as String,
      json['image'] as String?,
      (json['basicImageIdx'] as num).toInt(),
      json['agreeTerm'] as bool,
      json['agreePrivacy'] as bool,
      json['agreeSensitive'] as bool,
      json['agreeMarketing'] as bool,
      json['marketingModifiedAt'] == null
          ? null
          : DateTime.parse(json['marketingModifiedAt'] as String),
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'loginId': instance.loginId,
      'status': instance.status,
      'mobile': instance.mobile,
      'email': instance.email,
      'loginType': instance.loginType,
      'initAt': instance.initAt?.toIso8601String(),
      'loginAt': instance.loginAt?.toIso8601String(),
      'logoutAt': instance.logoutAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'nickname': instance.nickname,
      'image': instance.image,
      'basicImageIdx': instance.basicImageIdx,
      'agreeTerm': instance.agreeTerm,
      'agreePrivacy': instance.agreePrivacy,
      'agreeSensitive': instance.agreeSensitive,
      'agreeMarketing': instance.agreeMarketing,
      'marketingModifiedAt': instance.marketingModifiedAt?.toIso8601String(),
    };
