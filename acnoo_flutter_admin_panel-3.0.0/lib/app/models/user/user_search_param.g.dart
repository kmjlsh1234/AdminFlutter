// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchParam _$UserSearchParamFromJson(Map<String, dynamic> json) =>
    UserSearchParam(
      json['searchType'] as String?,
      json['searchValue'] as String?,
      json['searchDateType'] as String?,
      json['startDate'] as String?,
      json['endDate'] as String?,
      (json['page'] as num).toInt(),
      (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$UserSearchParamToJson(UserSearchParam instance) =>
    <String, dynamic>{
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'page': instance.page,
      'limit': instance.limit,
    };
