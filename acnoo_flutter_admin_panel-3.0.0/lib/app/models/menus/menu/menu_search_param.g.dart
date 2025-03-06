// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuSearchParam _$MenuSearchParamFromJson(Map<String, dynamic> json) =>
    MenuSearchParam(
      searchType:
          $enumDecodeNullable(_$MenuSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      visibility:
          $enumDecodeNullable(_$MenuVisibilityEnumMap, json['visibility']),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$MenuSearchParamToJson(MenuSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': _$MenuSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
      'visibility': _$MenuVisibilityEnumMap[instance.visibility],
    };

const _$MenuSearchTypeEnumMap = {
  MenuSearchType.NAME: 'NAME',
  MenuSearchType.PATH: 'PATH',
};

const _$MenuVisibilityEnumMap = {
  MenuVisibility.VISIBLE: 'VISIBLE',
  MenuVisibility.INVISIBLE: 'INVISIBLE',
};
