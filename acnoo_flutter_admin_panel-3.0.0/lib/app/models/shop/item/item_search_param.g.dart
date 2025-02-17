// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemSearchParam _$ItemSearchParamFromJson(Map<String, dynamic> json) =>
    ItemSearchParam(
      json['categoryId'] as String?,
      json['searchType'] as String?,
      json['searchValue'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemSearchParamToJson(ItemSearchParam instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'page': instance.page,
      'limit': instance.limit,
    };
