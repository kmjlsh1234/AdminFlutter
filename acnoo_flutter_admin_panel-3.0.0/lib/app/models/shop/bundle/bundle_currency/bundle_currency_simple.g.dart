// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_currency_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleCurrencySimple _$BundleCurrencySimpleFromJson(
        Map<String, dynamic> json) =>
    BundleCurrencySimple(
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$BundleCurrencySimpleToJson(
        BundleCurrencySimple instance) =>
    <String, dynamic>{
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'count': instance.count,
    };

const _$CurrencyTypeEnumMap = {
  CurrencyType.DIAMOND: 'DIAMOND',
  CurrencyType.COIN: 'COIN',
  CurrencyType.CHIP: 'CHIP',
  CurrencyType.FREE: 'FREE',
  CurrencyType.EVENT: 'EVENT',
};
