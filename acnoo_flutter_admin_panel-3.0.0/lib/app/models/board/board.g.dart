// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      boardType: $enumDecode(_$BoardTypeEnumMap, json['boardType']),
      status: $enumDecode(_$BoardStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'boardType': _$BoardTypeEnumMap[instance.boardType]!,
      'status': _$BoardStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BoardTypeEnumMap = {
  BoardType.NOTICE: 'NOTICE',
  BoardType.EVENT: 'EVENT',
};

const _$BoardStatusEnumMap = {
  BoardStatus.PUBLISH: 'PUBLISH',
  BoardStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
