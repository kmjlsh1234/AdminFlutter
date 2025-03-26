// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privilege_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivilegeSearchParam _$PrivilegeSearchParamFromJson(
        Map<String, dynamic> json) =>
    PrivilegeSearchParam(
      searchType:
          $enumDecodeNullable(_$PrivilegeSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PrivilegeSearchParamToJson(
        PrivilegeSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': _$PrivilegeSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
    };

const _$PrivilegeSearchTypeEnumMap = {
  PrivilegeSearchType.NAME: 'NAME',
  PrivilegeSearchType.CODE: 'CODE',
};
