// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleSearchParam _$BundleSearchParamFromJson(Map<String, dynamic> json) =>
    BundleSearchParam(
      searchStatus: json['searchStatus'] as String?,
      searchType: json['searchType'] as String?,
      searchValue: json['searchValue'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$BundleSearchParamToJson(BundleSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchStatus': instance.searchStatus,
      'searchType': instance.searchType,
      'searchValue': instance.searchValue,
    };
