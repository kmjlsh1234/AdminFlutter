// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) => AppVersion(
      id: (json['id'] as num).toInt(),
      version: json['version'] as String,
      versionType: $enumDecode(_$AppVersionTypeEnumMap, json['versionType']),
      publishAt: json['publishAt'] == null
          ? null
          : DateTime.parse(json['publishAt'] as String),
      publishStatus: $enumDecode(_$PublishStatusEnumMap, json['publishStatus']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'versionType': _$AppVersionTypeEnumMap[instance.versionType]!,
      if (instance.publishAt?.toIso8601String() case final value?)
        'publishAt': value,
      'publishStatus': _$PublishStatusEnumMap[instance.publishStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AppVersionTypeEnumMap = {
  AppVersionType.FORCE: 'FORCE',
  AppVersionType.INDUCE: 'INDUCE',
  AppVersionType.BUNDLE: 'BUNDLE',
};

const _$PublishStatusEnumMap = {
  PublishStatus.PUBLISH: 'PUBLISH',
  PublishStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
