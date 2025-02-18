// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestAppVersion _$LatestAppVersionFromJson(Map<String, dynamic> json) =>
    LatestAppVersion(
      json['forceUpdateVersion'] as String?,
      json['induceUpdateVersion'] as String?,
      json['bundleUpdateVersion'] as String?,
    );

Map<String, dynamic> _$LatestAppVersionToJson(LatestAppVersion instance) =>
    <String, dynamic>{
      'forceUpdateVersion': instance.forceUpdateVersion,
      'induceUpdateVersion': instance.induceUpdateVersion,
      'bundleUpdateVersion': instance.bundleUpdateVersion,
    };
