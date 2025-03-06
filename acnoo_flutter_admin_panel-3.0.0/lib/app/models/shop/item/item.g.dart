// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      itemUnitId: (json['itemUnitId'] as num?)?.toInt(),
      sku: json['sku'] as String,
      unitSku: json['unitSku'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      num: (json['num'] as num?)?.toInt(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      status: $enumDecode(_$ItemStatusEnumMap, json['status']),
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      periodType: $enumDecode(_$ItemPeriodTypeEnumMap, json['periodType']),
      period: (json['period'] as num?)?.toInt(),
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      amount: (json['amount'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'itemUnitId': instance.itemUnitId,
      'sku': instance.sku,
      'unitSku': instance.unitSku,
      'name': instance.name,
      'description': instance.description,
      'num': instance.num,
      'stockQuantity': instance.stockQuantity,
      'status': _$ItemStatusEnumMap[instance.status]!,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'periodType': _$ItemPeriodTypeEnumMap[instance.periodType]!,
      'period': instance.period,
      'expiration': instance.expiration?.toIso8601String(),
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ItemStatusEnumMap = {
  ItemStatus.READY: 'READY',
  ItemStatus.ON_SALE: 'ON_SALE',
  ItemStatus.STOP_SELLING: 'STOP_SELLING',
  ItemStatus.REMOVED: 'REMOVED',
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
