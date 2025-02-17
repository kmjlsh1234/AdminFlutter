// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      (json['id'] as num).toInt(),
      (json['categoryId'] as num).toInt(),
      (json['itemUnitId'] as num?)?.toInt(),
      json['sku'] as String,
      json['unitSku'] as String?,
      json['name'] as String,
      json['description'] as String,
      (json['num'] as num?)?.toInt(),
      (json['stockQuantity'] as num?)?.toInt(),
      json['status'] as String,
      json['thumbnail'] as String,
      json['image'] as String,
      json['info'] as String,
      json['periodType'] as String,
      (json['period'] as num?)?.toInt(),
      json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      json['currencyType'] as String,
      (json['amount'] as num?)?.toInt(),
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
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
      'status': instance.status,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'periodType': instance.periodType,
      'period': instance.period,
      'expiration': instance.expiration?.toIso8601String(),
      'currencyType': instance.currencyType,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
