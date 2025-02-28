// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchParam _$UserSearchParamFromJson(Map<String, dynamic> json) =>
    UserSearchParam(
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      searchDateType: json['searchDateType'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$UserSearchParamToJson(UserSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
      'searchDateType': instance.searchDateType,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
