// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_mod_status_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleModStatusParam _$BundleModStatusParamFromJson(
        Map<String, dynamic> json) =>
    BundleModStatusParam(
      status: $enumDecode(_$BundleStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$BundleModStatusParamToJson(
        BundleModStatusParam instance) =>
    <String, dynamic>{
      'status': _$BundleStatusEnumMap[instance.status]!,
    };

const _$BundleStatusEnumMap = {
  BundleStatus.READY: 'READY',
  BundleStatus.ON_SALE: 'ON_SALE',
  BundleStatus.STOP_SELLING: 'STOP_SELLING',
  BundleStatus.REMOVED: 'REMOVED',
};
