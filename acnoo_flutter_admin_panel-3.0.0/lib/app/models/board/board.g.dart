// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['content'] as String,
      json['boardType'] as String,
      json['status'] as String,
      json['image'] as String?,
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'boardType': instance.boardType,
      'status': instance.status,
      'image': instance.image,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
