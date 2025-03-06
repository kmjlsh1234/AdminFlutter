// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSearchParam _$BoardSearchParamFromJson(Map<String, dynamic> json) =>
    BoardSearchParam(
      boardType: $enumDecodeNullable(_$BoardTypeEnumMap, json['boardType']),
      boardStatus:
          $enumDecodeNullable(_$BoardStatusEnumMap, json['boardStatus']),
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$BoardSearchParamToJson(BoardSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'boardType': _$BoardTypeEnumMap[instance.boardType],
      'boardStatus': _$BoardStatusEnumMap[instance.boardStatus],
      'searchValue': instance.searchValue,
    };

const _$BoardTypeEnumMap = {
  BoardType.NOTICE: 'NOTICE',
  BoardType.EVENT: 'EVENT',
};

const _$BoardStatusEnumMap = {
  BoardStatus.PUBLISH: 'PUBLISH',
  BoardStatus.NOT_PUBLISH: 'NOT_PUBLISH',
};
