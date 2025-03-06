// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drop_out_user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DropOutUserSearchParam _$DropOutUserSearchParamFromJson(
        Map<String, dynamic> json) =>
    DropOutUserSearchParam(
      searchType: $enumDecodeNullable(
          _$DropOutUserSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$DropOutUserSearchParamToJson(
        DropOutUserSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': _$DropOutUserSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

const _$DropOutUserSearchTypeEnumMap = {
  DropOutUserSearchType.EMAIL: 'EMAIL',
  DropOutUserSearchType.MOBILE: 'MOBILE',
};
