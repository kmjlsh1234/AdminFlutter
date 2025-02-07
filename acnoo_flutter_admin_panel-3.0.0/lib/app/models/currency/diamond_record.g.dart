// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiamondRecord _$DiamondRecordFromJson(Map<String, dynamic> json) =>
    DiamondRecord(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      json['changeType'] as String,
      (json['changeDiamond'] as num).toInt(),
      (json['resultDiamond'] as num).toInt(),
      json['changeDesc'] as String,
      json['idempotentKey'] as String,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$DiamondRecordToJson(DiamondRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': instance.changeType,
      'changeDiamond': instance.changeDiamond,
      'resultDiamond': instance.resultDiamond,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt,
    };
