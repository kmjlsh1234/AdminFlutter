// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardAddParam _$BoardAddParamFromJson(Map<String, dynamic> json) =>
    BoardAddParam(
      title: json['title'] as String,
      content: json['content'] as String,
      boardType: $enumDecode(_$BoardTypeEnumMap, json['boardType']),
      status: $enumDecode(_$BoardStatusEnumMap, json['status']),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$BoardAddParamToJson(BoardAddParam instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'boardType': _$BoardTypeEnumMap[instance.boardType]!,
      'status': _$BoardStatusEnumMap[instance.status]!,
      'image': instance.image,
    };

const _$BoardTypeEnumMap = {
  BoardType.NOTICE: 'NOTICE',
  BoardType.EVENT: 'EVENT',
};

const _$BoardStatusEnumMap = {
  BoardStatus.PUBLISH: 'PUBLISH',
  BoardStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
