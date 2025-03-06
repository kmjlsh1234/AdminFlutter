// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionSearchParam _$AppVersionSearchParamFromJson(
        Map<String, dynamic> json) =>
    AppVersionSearchParam(
      versionType:
          $enumDecodeNullable(_$AppVersionTypeEnumMap, json['versionType']),
    );

Map<String, dynamic> _$AppVersionSearchParamToJson(
        AppVersionSearchParam instance) =>
    <String, dynamic>{
      'versionType': _$AppVersionTypeEnumMap[instance.versionType],
    };

const _$AppVersionTypeEnumMap = {
  AppVersionType.FORCE: 'FORCE',
  AppVersionType.INDUCE: 'INDUCE',
  AppVersionType.BUNDLE: 'BUNDLE',
};
