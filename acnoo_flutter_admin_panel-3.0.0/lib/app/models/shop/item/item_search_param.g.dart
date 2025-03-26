// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemSearchParam _$ItemSearchParamFromJson(Map<String, dynamic> json) =>
    ItemSearchParam(
      categoryId: (json['categoryId'] as num?)?.toInt(),
      searchStatus:
          $enumDecodeNullable(_$ItemStatusEnumMap, json['searchStatus']),
      searchType:
          $enumDecodeNullable(_$ItemSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemSearchParamToJson(ItemSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'categoryId': instance.categoryId,
      'searchStatus': _$ItemStatusEnumMap[instance.searchStatus],
      'searchType': _$ItemSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
    };

const _$ItemStatusEnumMap = {
  ItemStatus.READY: 'READY',
  ItemStatus.ON_SALE: 'ON_SALE',
  ItemStatus.STOP_SELLING: 'STOP_SELLING',
  ItemStatus.REMOVED: 'REMOVED',
};

const _$ItemSearchTypeEnumMap = {
  ItemSearchType.NAME: 'NAME',
  ItemSearchType.SKU: 'SKU',
};
