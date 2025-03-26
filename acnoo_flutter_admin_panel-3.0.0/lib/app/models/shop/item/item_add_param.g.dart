// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemAddParam _$ItemAddParamFromJson(Map<String, dynamic> json) => ItemAddParam(
      categoryId: (json['categoryId'] as num).toInt(),
      sku: json['sku'] as String,
      unitSku: json['unitSku'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      num: (json['num'] as num?)?.toInt(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      periodType: $enumDecode(_$ItemPeriodTypeEnumMap, json['periodType']),
      period: (json['period'] as num?)?.toInt(),
      expiration: json['expiration'] as String?,
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ItemAddParamToJson(ItemAddParam instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'sku': instance.sku,
      'unitSku': instance.unitSku,
      'name': instance.name,
      'description': instance.description,
      'num': instance.num,
      'stockQuantity': instance.stockQuantity,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'periodType': _$ItemPeriodTypeEnumMap[instance.periodType]!,
      'period': instance.period,
      'expiration': instance.expiration,
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'amount': instance.amount,
    };

const _$ItemPeriodTypeEnumMap = {
  ItemPeriodType.NONE: 'NONE',
  ItemPeriodType.DAY: 'DAY',
  ItemPeriodType.MONTH: 'MONTH',
  ItemPeriodType.EXPIRATION: 'EXPIRATION',
};

const _$CurrencyTypeEnumMap = {
  CurrencyType.DIAMOND: 'DIAMOND',
  CurrencyType.COIN: 'COIN',
  CurrencyType.CHIP: 'CHIP',
  CurrencyType.FREE: 'FREE',
  CurrencyType.EVENT: 'EVENT',
};
