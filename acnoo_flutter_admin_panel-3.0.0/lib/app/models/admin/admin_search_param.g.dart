// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSearchParam _$AdminSearchParamFromJson(Map<String, dynamic> json) =>
    AdminSearchParam(
      roleId: (json['roleId'] as num?)?.toInt(),
      searchType:
          $enumDecodeNullable(_$AdminSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$AdminSearchParamToJson(AdminSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'roleId': instance.roleId,
      'searchType': _$AdminSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
    };

const _$AdminSearchTypeEnumMap = {
  AdminSearchType.NAME: 'NAME',
  AdminSearchType.EMAIL: 'EMAIL',
  AdminSearchType.MOBILE: 'MOBILE',
};
