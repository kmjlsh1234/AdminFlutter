// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSearchParam _$AdminSearchParamFromJson(Map<String, dynamic> json) =>
    AdminSearchParam(
      json['searchType'] as String?,
      json['searchValue'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$AdminSearchParamToJson(AdminSearchParam instance) =>
    <String, dynamic>{
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'page': instance.page,
      'limit': instance.limit,
    };
