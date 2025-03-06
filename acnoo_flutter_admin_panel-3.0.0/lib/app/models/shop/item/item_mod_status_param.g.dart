// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_mod_status_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModStatusParam _$ItemModStatusParamFromJson(Map<String, dynamic> json) =>
    ItemModStatusParam(
      status: $enumDecode(_$ItemStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ItemModStatusParamToJson(ItemModStatusParam instance) =>
    <String, dynamic>{
      'status': _$ItemStatusEnumMap[instance.status]!,
    };

const _$ItemStatusEnumMap = {
  ItemStatus.READY: 'READY',
  ItemStatus.ON_SALE: 'ON_SALE',
  ItemStatus.STOP_SELLING: 'STOP_SELLING',
  ItemStatus.REMOVED: 'REMOVED',
};
