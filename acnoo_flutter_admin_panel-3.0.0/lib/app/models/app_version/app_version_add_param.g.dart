// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionAddParam _$AppVersionAddParamFromJson(Map<String, dynamic> json) =>
    AppVersionAddParam(
      json['version'] as String,
      json['versionType'] as String,
      json['publishAt'] as String,
      json['publishStatus'] as String,
    );

Map<String, dynamic> _$AppVersionAddParamToJson(AppVersionAddParam instance) =>
    <String, dynamic>{
      'version': instance.version,
      'versionType': instance.versionType,
      'publishAt': instance.publishAt,
      'publishStatus': instance.publishStatus,
    };
