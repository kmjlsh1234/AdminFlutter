// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_currency_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseCurrencyRecord _$BaseCurrencyRecordFromJson(Map<String, dynamic> json) =>
    BaseCurrencyRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: json['changeType'] as String,
      changeAmount: (json['changeAmount'] as num).toInt(),
      resultAmount: (json['resultAmount'] as num).toInt(),
      changeDesc: json['changeDesc'] as String,
      idempotentKey: json['idempotentKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BaseCurrencyRecordToJson(BaseCurrencyRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeAmount': instance.changeAmount,
      'resultAmount': instance.resultAmount,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt.toIso8601String(),
    };
