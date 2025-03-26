// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionAddParam _$AppVersionAddParamFromJson(Map<String, dynamic> json) =>
    AppVersionAddParam(
      version: json['version'] as String,
      versionType: $enumDecode(_$AppVersionTypeEnumMap, json['versionType']),
      publishAt: json['publishAt'] as String?,
      publishStatus: $enumDecode(_$PublishStatusEnumMap, json['publishStatus']),
    );

Map<String, dynamic> _$AppVersionAddParamToJson(AppVersionAddParam instance) =>
    <String, dynamic>{
      'version': instance.version,
      'versionType': _$AppVersionTypeEnumMap[instance.versionType]!,
      if (instance.publishAt case final value?) 'publishAt': value,
      'publishStatus': _$PublishStatusEnumMap[instance.publishStatus]!,
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
