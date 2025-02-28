// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemSearchParam _$ItemSearchParamFromJson(Map<String, dynamic> json) =>
    ItemSearchParam(
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemSearchParamToJson(ItemSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
    };
