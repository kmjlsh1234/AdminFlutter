// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitSearchParam _$ItemUnitSearchParamFromJson(Map<String, dynamic> json) =>
    ItemUnitSearchParam(
      json['itemUnitType'] as String?,
      json['searchType'] as String?,
      json['searchValue'] as String?,
      json['searchDateType'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ItemUnitSearchParamToJson(
        ItemUnitSearchParam instance) =>
    <String, dynamic>{
      'itemUnitType': instance.itemUnitType,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'limit': instance.limit,
    };
