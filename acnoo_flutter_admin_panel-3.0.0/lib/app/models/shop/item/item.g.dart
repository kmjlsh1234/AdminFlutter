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
      status: json['status'] as String,
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      periodType: json['periodType'] as String,
      period: (json['period'] as num?)?.toInt(),
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      currencyType: json['currencyType'] as String,
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
