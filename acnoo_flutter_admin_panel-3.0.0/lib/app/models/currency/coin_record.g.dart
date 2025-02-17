// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRecord _$CoinRecordFromJson(Map<String, dynamic> json) => CoinRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: json['changeType'] as String,
      changeCoin: (json['changeCoin'] as num).toInt(),
      resultCoin: (json['resultCoin'] as num).toInt(),
      changeDesc: json['changeDesc'] as String,
      idempotentKey: json['idempotentKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CoinRecordToJson(CoinRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt.toIso8601String(),
      'changeCoin': instance.changeCoin,
      'resultCoin': instance.resultCoin,
    };
