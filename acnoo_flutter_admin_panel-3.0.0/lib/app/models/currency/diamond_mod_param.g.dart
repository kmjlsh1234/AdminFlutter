// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiamondModParam _$DiamondModParamFromJson(Map<String, dynamic> json) =>
    DiamondModParam(
      freeAmount: (json['freeAmount'] as num?)?.toInt(),
      androidAmount: (json['androidAmount'] as num?)?.toInt(),
      iosAmount: (json['iosAmount'] as num?)?.toInt(),
      paidAmount: (json['paidAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DiamondModParamToJson(DiamondModParam instance) =>
    <String, dynamic>{
      'freeAmount': instance.freeAmount,
      'androidAmount': instance.androidAmount,
      'iosAmount': instance.iosAmount,
      'paidAmount': instance.paidAmount,
    };
