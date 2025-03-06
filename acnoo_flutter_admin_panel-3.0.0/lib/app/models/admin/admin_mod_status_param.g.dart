// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mod_status_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModStatusParam _$AdminModStatusParamFromJson(Map<String, dynamic> json) =>
    AdminModStatusParam(
      status: $enumDecode(_$AdminStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AdminModStatusParamToJson(
        AdminModStatusParam instance) =>
    <String, dynamic>{
      'status': _$AdminStatusEnumMap[instance.status]!,
    };

const _$AdminStatusEnumMap = {
  AdminStatus.NORMAL: 'NORMAL',
  AdminStatus.LOGOUT: 'LOGOUT',
  AdminStatus.STOP: 'STOP',
  AdminStatus.BAN: 'BAN',
  AdminStatus.EXIT: 'EXIT',
};
