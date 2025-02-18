// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSearchParam _$BoardSearchParamFromJson(Map<String, dynamic> json) =>
    BoardSearchParam(
      json['boardType'] as String?,
      json['boardStatus'] as String?,
      json['searchDateType'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$BoardSearchParamToJson(BoardSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'boardType': instance.boardType,
      'boardStatus': instance.boardStatus,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
