// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemAddParam _$ItemAddParamFromJson(Map<String, dynamic> json) => ItemAddParam(
      (json['categoryId'] as num).toInt(),
      json['unitSku'] as String,
      json['sku'] as String,
      json['name'] as String,
      json['description'] as String,
      (json['num'] as num).toInt(),
      (json['stockQuantity'] as num).toInt(),
      json['thumbnail'] as String,
      json['image'] as String,
      json['info'] as String,
      json['periodType'] as String,
      (json['period'] as num).toInt(),
      json['expiration'] as String,
      json['currencyType'] as String,
      (json['amount'] as num).toInt(),
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
