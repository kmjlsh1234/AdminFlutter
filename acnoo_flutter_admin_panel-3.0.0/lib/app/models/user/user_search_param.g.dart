// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchParam _$UserSearchParamFromJson(Map<String, dynamic> json) =>
    UserSearchParam(
      searchStatus:
          $enumDecodeNullable(_$UserStatusEnumMap, json['searchStatus']),
      loginType: $enumDecodeNullable(_$LoginTypeEnumMap, json['loginType']),
      searchType:
          $enumDecodeNullable(_$UserSearchTypeEnumMap, json['searchType']),
      searchValue: json['searchValue'] as String?,
      searchDateType: $enumDecodeNullable(
          _$UserSearchDateTypeEnumMap, json['searchDateType']),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$UserSearchParamToJson(UserSearchParam instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'searchStatus': _$UserStatusEnumMap[instance.searchStatus],
      'loginType': _$LoginTypeEnumMap[instance.loginType],
      'searchType': _$UserSearchTypeEnumMap[instance.searchType],
      'searchValue': instance.searchValue,
      'searchDateType': _$UserSearchDateTypeEnumMap[instance.searchDateType],
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

const _$UserStatusEnumMap = {
  UserStatus.NORMAL: 'NORMAL',
  UserStatus.LOGOUT: 'LOGOUT',
  UserStatus.STOP: 'STOP',
  UserStatus.BAN: 'BAN',
  UserStatus.TRY_EXIT: 'TRY_EXIT',
  UserStatus.EXIT: 'EXIT',
};

const _$LoginTypeEnumMap = {
  LoginType.EMAIL: 'EMAIL',
  LoginType.MOBILE: 'MOBILE',
  LoginType.SOCIAL: 'SOCIAL',
  LoginType.ID_PASS: 'ID_PASS',
  LoginType.GUEST: 'GUEST',
};

const _$UserSearchTypeEnumMap = {
  UserSearchType.EMAIL: 'EMAIL',
  UserSearchType.NICKNAME: 'NICKNAME',
  UserSearchType.MOBILE: 'MOBILE',
};

const _$UserSearchDateTypeEnumMap = {
  UserSearchDateType.CREATED_AT: 'CREATED_AT',
  UserSearchDateType.UPDATED_AT: 'UPDATED_AT',
  UserSearchDateType.LOGIN_AT: 'LOGIN_AT',
};
