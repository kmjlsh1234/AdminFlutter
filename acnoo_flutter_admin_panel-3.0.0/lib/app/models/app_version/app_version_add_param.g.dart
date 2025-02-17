// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionAddParam _$AppVersionAddParamFromJson(Map<String, dynamic> json) =>
    AppVersionAddParam(
      version: json['version'] as String,
      versionType: json['versionType'] as String,
      publishAt: json['publishAt'] as String?,
      publishStatus: json['publishStatus'] as String,
    );

Map<String, dynamic> _$AppVersionAddParamToJson(AppVersionAddParam instance) =>
    <String, dynamic>{
      'version': instance.version,
      'versionType': instance.versionType,
      if (instance.publishAt case final value?) 'publishAt': value,
      'publishStatus': instance.publishStatus,
    };
