// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiamondRecord _$DiamondRecordFromJson(Map<String, dynamic> json) =>
    DiamondRecord(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      changeType: $enumDecode(_$ChangeTypeEnumMap, json['changeType']),
      os: $enumDecode(_$OsEnumMap, json['os']),
      changeDiamond: (json['changeDiamond'] as num).toInt(),
      resultFreeDiamond: (json['resultFreeDiamond'] as num).toInt(),
      resultAndroidDiamond: (json['resultAndroidDiamond'] as num).toInt(),
      resultIosDiamond: (json['resultIosDiamond'] as num).toInt(),
      resultPaidDiamond: (json['resultPaidDiamond'] as num).toInt(),
      changeDesc: json['changeDesc'] as String,
      idempotentKey: json['idempotentKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DiamondRecordToJson(DiamondRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'changeType': _$ChangeTypeEnumMap[instance.changeType]!,
      'os': _$OsEnumMap[instance.os]!,
      'changeDiamond': instance.changeDiamond,
      'resultFreeDiamond': instance.resultFreeDiamond,
      'resultAndroidDiamond': instance.resultAndroidDiamond,
      'resultIosDiamond': instance.resultIosDiamond,
      'resultPaidDiamond': instance.resultPaidDiamond,
      'changeDesc': instance.changeDesc,
      'idempotentKey': instance.idempotentKey,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ChangeTypeEnumMap = {
  ChangeType.NONE: 'NONE',
  ChangeType.ADD: 'ADD',
  ChangeType.USE: 'USE',
};

const _$OsEnumMap = {
  Os.WEB: 'WEB',
  Os.ANDROID: 'ANDROID',
  Os.IOS: 'IOS',
  Os.OTHER: 'OTHER',
};
