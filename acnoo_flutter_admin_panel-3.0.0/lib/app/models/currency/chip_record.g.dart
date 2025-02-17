// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChipRecord _$ChipRecordFromJson(Map<String, dynamic> json) => ChipRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: json['changeType'] as String,
      changeChip: (json['changeChip'] as num).toInt(),
      resultChip: (json['resultChip'] as num).toInt(),
      changeDesc: json['changeDesc'] as String,
      idempotentKey: json['idempotentKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChipRecordToJson(ChipRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt.toIso8601String(),
      'changeChip': instance.changeChip,
      'resultChip': instance.resultChip,
    };
