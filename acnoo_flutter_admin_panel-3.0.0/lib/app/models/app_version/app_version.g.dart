// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) => AppVersion(
      (json['id'] as num).toInt(),
      json['version'] as String,
      json['versionType'] as String,
      json['publishAt'] as String,
      json['publishStatus'] as String,
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'versionType': instance.versionType,
      'publishAt': instance.publishAt,
      'publishStatus': instance.publishStatus,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
