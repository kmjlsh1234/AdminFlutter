// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSearchParam _$AdminSearchParamFromJson(Map<String, dynamic> json) =>
    AdminSearchParam(
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$AdminSearchParamToJson(AdminSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
    };
