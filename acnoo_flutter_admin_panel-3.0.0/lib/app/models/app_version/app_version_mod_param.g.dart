// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionModParam _$AppVersionModParamFromJson(Map<String, dynamic> json) =>
    AppVersionModParam(
      publishAt: json['publishAt'] as String?,
      publishStatus:
          $enumDecodeNullable(_$PublishStatusEnumMap, json['publishStatus']),
    );

Map<String, dynamic> _$AppVersionModParamToJson(AppVersionModParam instance) =>
    <String, dynamic>{
      'publishAt': instance.publishAt,
      'publishStatus': _$PublishStatusEnumMap[instance.publishStatus],
    };

const _$PublishStatusEnumMap = {
  PublishStatus.PUBLISH: 'PUBLISH',
  PublishStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
