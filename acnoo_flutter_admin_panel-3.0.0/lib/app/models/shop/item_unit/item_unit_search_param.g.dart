// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitSearchParam _$ItemUnitSearchParamFromJson(Map<String, dynamic> json) =>
    ItemUnitSearchParam(
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemUnitSearchParamToJson(
        ItemUnitSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
    };
