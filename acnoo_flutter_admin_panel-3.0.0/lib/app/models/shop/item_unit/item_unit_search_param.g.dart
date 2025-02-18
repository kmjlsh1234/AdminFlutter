// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitSearchParam _$ItemUnitSearchParamFromJson(Map<String, dynamic> json) =>
    ItemUnitSearchParam(
      itemUnitType: json['itemUnitType'] as String?,
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      searchDateType: json['searchDateType'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemUnitSearchParamToJson(
        ItemUnitSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'itemUnitType': instance.itemUnitType,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
