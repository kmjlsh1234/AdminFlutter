// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drop_out_user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DropOutUserSearchParam _$DropOutUserSearchParamFromJson(
        Map<String, dynamic> json) =>
    DropOutUserSearchParam(
      json['searchType'] as String?,
      json['searchValue'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$DropOutUserSearchParamToJson(
        DropOutUserSearchParam instance) =>
    <String, dynamic>{
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'limit': instance.limit,
    };
