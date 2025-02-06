// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionSearchParam _$AppVersionSearchParamFromJson(
        Map<String, dynamic> json) =>
    AppVersionSearchParam(
      json['versionType'] as String?,
      json['sortType'] as String?,
      json['orderBy'] as String?,
    );

Map<String, dynamic> _$AppVersionSearchParamToJson(
        AppVersionSearchParam instance) =>
    <String, dynamic>{
      'versionType': instance.versionType,
      'sortType': instance.sortType,
      'orderBy': instance.orderBy,
    };
