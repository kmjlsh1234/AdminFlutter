// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardAddParam _$BoardAddParamFromJson(Map<String, dynamic> json) =>
    BoardAddParam(
      json['title'] as String,
      json['content'] as String,
      json['boardType'] as String,
      json['status'] as String,
      json['image'] as String?,
    );

Map<String, dynamic> _$BoardAddParamToJson(BoardAddParam instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'boardType': instance.boardType,
      'status': instance.status,
      'image': instance.image,
    };
