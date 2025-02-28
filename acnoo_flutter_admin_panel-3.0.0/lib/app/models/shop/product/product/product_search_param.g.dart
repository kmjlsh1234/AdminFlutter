// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchParam _$ProductSearchParamFromJson(Map<String, dynamic> json) =>
    ProductSearchParam(
      searchStatus: json['searchStatus'] as String?,
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ProductSearchParamToJson(ProductSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchStatus': instance.searchStatus,
      'searchValue': instance.searchValue,
    };
