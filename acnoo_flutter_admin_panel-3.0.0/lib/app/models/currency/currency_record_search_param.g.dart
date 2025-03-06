// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_record_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyRecordSearchParam _$CurrencyRecordSearchParamFromJson(
        Map<String, dynamic> json) =>
    CurrencyRecordSearchParam(
      userId: (json['userId'] as num).toInt(),
      changeType: $enumDecodeNullable(_$ChangeTypeEnumMap, json['changeType']),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$CurrencyRecordSearchParamToJson(
        CurrencyRecordSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'userId': instance.userId,
      'changeType': _$ChangeTypeEnumMap[instance.changeType],
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

const _$ChangeTypeEnumMap = {
  ChangeType.NONE: 'NONE',
  ChangeType.ADD: 'ADD',
  ChangeType.USE: 'USE',
};
