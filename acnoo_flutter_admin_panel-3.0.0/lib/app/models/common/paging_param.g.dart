// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagingParam _$PagingParamFromJson(Map<String, dynamic> json) => PagingParam(
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PagingParamToJson(PagingParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
    };
