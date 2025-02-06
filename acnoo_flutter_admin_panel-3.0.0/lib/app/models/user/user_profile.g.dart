// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      (json['userId'] as num).toInt(),
      json['status'] as String,
      json['mobile'] as String,
      json['email'] as String,
      json['userType'] as String,
      json['loginAt'] as String?,
      json['logoutAt'] as String?,
      json['createdAt'] as String,
      json['updatedAt'] as String,
      json['nickname'] as String,
      json['image'] as String,
      (json['basicImageIdx'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'status': instance.status,
      'mobile': instance.mobile,
      'email': instance.email,
      'userType': instance.userType,
      'loginAt': instance.loginAt,
      'logoutAt': instance.logoutAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'nickname': instance.nickname,
      'image': instance.image,
      'basicImageIdx': instance.basicImageIdx,
    };
