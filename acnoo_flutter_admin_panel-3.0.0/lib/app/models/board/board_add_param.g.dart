// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardAddParam _$BoardAddParamFromJson(Map<String, dynamic> json) =>
    BoardAddParam(
      title: json['title'] as String,
      content: json['content'] as String,
      boardType: json['boardType'] as String,
      status: json['status'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$BoardAddParamToJson(BoardAddParam instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'boardType': instance.boardType,
      'status': instance.status,
      'image': instance.image,
    };
