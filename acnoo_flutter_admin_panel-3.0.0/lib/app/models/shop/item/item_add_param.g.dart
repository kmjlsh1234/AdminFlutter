// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemAddParam _$ItemAddParamFromJson(Map<String, dynamic> json) => ItemAddParam(
      categoryId: (json['categoryId'] as num).toInt(),
      sku: json['sku'] as String,
      unitSku: json['unitSku'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      num: (json['num'] as num?)?.toInt(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      periodType: json['periodType'] as String,
      period: (json['period'] as num?)?.toInt(),
      expiration: json['expiration'] as String?,
      currencyType: json['currencyType'] as String,
      amount: (json['amount'] as num).toInt(),
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
      'periodType': instance.periodType,
      'period': instance.period,
      'expiration': instance.expiration,
      'currencyType': instance.currencyType,
      'amount': instance.amount,
    };
