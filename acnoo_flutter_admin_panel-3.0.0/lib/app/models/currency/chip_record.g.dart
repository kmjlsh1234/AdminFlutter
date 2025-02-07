// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChipRecord _$ChipRecordFromJson(Map<String, dynamic> json) => ChipRecord(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      json['changeType'] as String,
      (json['changeChip'] as num).toInt(),
      (json['resultChip'] as num).toInt(),
      json['changeDesc'] as String,
      json['idempotentKey'] as String,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$ChipRecordToJson(ChipRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeChip': instance.changeChip,
      'resultChip': instance.resultChip,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt,
    };
