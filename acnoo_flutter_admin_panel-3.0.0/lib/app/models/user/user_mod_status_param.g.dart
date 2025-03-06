// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mod_status_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModStatusParam _$UserModStatusParamFromJson(Map<String, dynamic> json) =>
    UserModStatusParam(
      $enumDecode(_$UserStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UserModStatusParamToJson(UserModStatusParam instance) =>
    <String, dynamic>{
      'status': _$UserStatusEnumMap[instance.status]!,
    };

const _$UserStatusEnumMap = {
  UserStatus.NORMAL: 'NORMAL',
  UserStatus.LOGOUT: 'LOGOUT',
  UserStatus.STOP: 'STOP',
  UserStatus.BAN: 'BAN',
  UserStatus.TRY_EXIT: 'TRY_EXIT',
  UserStatus.EXIT: 'EXIT',
};
