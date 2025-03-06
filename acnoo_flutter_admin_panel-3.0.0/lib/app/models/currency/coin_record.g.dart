// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRecord _$CoinRecordFromJson(Map<String, dynamic> json) => CoinRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: $enumDecode(_$ChangeTypeEnumMap, json['changeType']),
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
      'changeType': _$ChangeTypeEnumMap[instance.changeType]!,
      'changeCoin': instance.changeCoin,
      'resultCoin': instance.resultCoin,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ChangeTypeEnumMap = {
  ChangeType.NONE: 'NONE',
  ChangeType.ADD: 'ADD',
  ChangeType.USE: 'USE',
};
