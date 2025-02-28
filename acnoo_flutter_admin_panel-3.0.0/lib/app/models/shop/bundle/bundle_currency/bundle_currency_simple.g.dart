// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_currency_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleCurrencySimple _$BundleCurrencySimpleFromJson(
        Map<String, dynamic> json) =>
    BundleCurrencySimple(
      currencyType: json['currencyType'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$BundleCurrencySimpleToJson(
        BundleCurrencySimple instance) =>
    <String, dynamic>{
      'currencyType': instance.currencyType,
      'count': instance.count,
    };
