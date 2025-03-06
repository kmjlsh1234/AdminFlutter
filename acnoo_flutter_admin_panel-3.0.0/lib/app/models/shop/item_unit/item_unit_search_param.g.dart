// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitSearchParam _$ItemUnitSearchParamFromJson(Map<String, dynamic> json) =>
    ItemUnitSearchParam(
      searchType:
          $enumDecodeNullable(_$ItemUnitSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemUnitSearchParamToJson(
        ItemUnitSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': _$ItemUnitSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
    };

const _$ItemUnitSearchTypeEnumMap = {
  ItemUnitSearchType.NAME: 'NAME',
  ItemUnitSearchType.SKU: 'SKU',
};
