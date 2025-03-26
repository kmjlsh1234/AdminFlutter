// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleCurrency _$BundleCurrencyFromJson(Map<String, dynamic> json) =>
    BundleCurrency(
      id: (json['id'] as num).toInt(),
      bundleId: (json['bundleId'] as num).toInt(),
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      count: (json['count'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BundleCurrencyToJson(BundleCurrency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bundleId': instance.bundleId,
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'count': instance.count,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CurrencyTypeEnumMap = {
  CurrencyType.DIAMOND: 'DIAMOND',
  CurrencyType.COIN: 'COIN',
  CurrencyType.CHIP: 'CHIP',
  CurrencyType.FREE: 'FREE',
  CurrencyType.EVENT: 'EVENT',
};
