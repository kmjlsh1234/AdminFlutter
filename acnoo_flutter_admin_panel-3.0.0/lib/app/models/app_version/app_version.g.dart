// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) => AppVersion(
      id: (json['id'] as num).toInt(),
      version: json['version'] as String,
      versionType: json['versionType'] as String,
      publishAt: json['publishAt'] == null
          ? null
          : DateTime.parse(json['publishAt'] as String),
      publishStatus: json['publishStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'versionType': instance.versionType,
      if (instance.publishAt?.toIso8601String() case final value?)
        'publishAt': value,
      'publishStatus': instance.publishStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
