// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiamondRecord _$DiamondRecordFromJson(Map<String, dynamic> json) =>
    DiamondRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: json['changeType'] as String,
      changeDiamond: (json['changeDiamond'] as num).toInt(),
      resultDiamond: (json['resultDiamond'] as num).toInt(),
      changeDesc: json['changeDesc'] as String,
      idempotentKey: json['idempotentKey'] as String,
      createdAt: json['createdAt'] as String,
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
