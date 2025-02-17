// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_currency_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleCurrencyModParam _$BundleCurrencyModParamFromJson(
        Map<String, dynamic> json) =>
    BundleCurrencyModParam(
      bundleCurrencies: (json['bundleCurrencies'] as List<dynamic>)
          .map((e) => BundleCurrencySimple.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundleCurrencyModParamToJson(
        BundleCurrencyModParam instance) =>
    <String, dynamic>{
      'bundleCurrencies': instance.bundleCurrencies,
    };
