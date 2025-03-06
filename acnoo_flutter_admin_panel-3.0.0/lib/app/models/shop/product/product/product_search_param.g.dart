// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchParam _$ProductSearchParamFromJson(Map<String, dynamic> json) =>
    ProductSearchParam(
      searchStatus:
          $enumDecodeNullable(_$ProductStatusEnumMap, json['searchStatus']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ProductSearchParamToJson(ProductSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchStatus': _$ProductStatusEnumMap[instance.searchStatus],
      'searchValue': instance.searchValue,
    };

const _$ProductStatusEnumMap = {
  ProductStatus.NONE: 'NONE',
  ProductStatus.READY: 'READY',
  ProductStatus.ON_SALE: 'ON_SALE',
  ProductStatus.STOP_SELLING: 'STOP_SELLING',
  ProductStatus.REMOVED: 'REMOVED',
};
