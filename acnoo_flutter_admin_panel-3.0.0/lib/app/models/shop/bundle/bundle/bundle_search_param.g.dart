// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleSearchParam _$BundleSearchParamFromJson(Map<String, dynamic> json) =>
    BundleSearchParam(
      searchStatus:
          $enumDecodeNullable(_$BundleStatusEnumMap, json['searchStatus']),
      searchType:
          $enumDecodeNullable(_$BundleSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$BundleSearchParamToJson(BundleSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchStatus': _$BundleStatusEnumMap[instance.searchStatus],
      'searchType': _$BundleSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
    };

const _$BundleStatusEnumMap = {
  BundleStatus.READY: 'READY',
  BundleStatus.ON_SALE: 'ON_SALE',
  BundleStatus.STOP_SELLING: 'STOP_SELLING',
  BundleStatus.REMOVED: 'REMOVED',
};

const _$BundleSearchTypeEnumMap = {
  BundleSearchType.NAME: 'NAME',
  BundleSearchType.SKU: 'SKU',
};
