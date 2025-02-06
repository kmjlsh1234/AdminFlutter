// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_record_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyRecordSearchParam _$CurrencyRecordSearchParamFromJson(
        Map<String, dynamic> json) =>
    CurrencyRecordSearchParam(
      (json['userId'] as num).toInt(),
      json['changeType'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$CurrencyRecordSearchParamToJson(
        CurrencyRecordSearchParam instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'changeType': instance.changeType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'limit': instance.limit,
    };
