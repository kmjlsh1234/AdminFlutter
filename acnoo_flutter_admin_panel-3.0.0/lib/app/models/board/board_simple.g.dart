// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSimple _$BoardSimpleFromJson(Map<String, dynamic> json) => BoardSimple(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      status: $enumDecode(_$BoardStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BoardSimpleToJson(BoardSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': _$BoardStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BoardStatusEnumMap = {
  BoardStatus.PUBLISH: 'PUBLISH',
  BoardStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
