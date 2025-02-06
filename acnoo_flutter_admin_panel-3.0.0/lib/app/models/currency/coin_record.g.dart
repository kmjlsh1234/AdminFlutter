// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRecord _$CoinRecordFromJson(Map<String, dynamic> json) => CoinRecord(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      json['changeType'] as String,
      (json['changeCoin'] as num).toInt(),
      (json['resultCoin'] as num).toInt(),
      json['changeDesc'] as String,
      json['idempotentKey'] as String,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$CoinRecordToJson(CoinRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeCoin': instance.changeCoin,
      'resultCoin': instance.resultCoin,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt,
    };
