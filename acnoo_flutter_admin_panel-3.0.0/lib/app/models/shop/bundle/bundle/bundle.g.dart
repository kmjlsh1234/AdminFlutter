// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bundle _$BundleFromJson(Map<String, dynamic> json) => Bundle(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$BundleStatusEnumMap, json['status']),
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      countPerPerson: (json['countPerPerson'] as num?)?.toInt(),
      saleStartDate: json['saleStartDate'] == null
          ? null
          : DateTime.parse(json['saleStartDate'] as String),
      saleEndDate: json['saleEndDate'] == null
          ? null
          : DateTime.parse(json['saleEndDate'] as String),
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      amount: (json['amount'] as num).toInt(),
      originAmount: (json['originAmount'] as num).toInt(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BundleToJson(Bundle instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'description': instance.description,
      'status': _$BundleStatusEnumMap[instance.status]!,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'countPerPerson': instance.countPerPerson,
      'saleStartDate': instance.saleStartDate?.toIso8601String(),
      'saleEndDate': instance.saleEndDate?.toIso8601String(),
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'amount': instance.amount,
      'originAmount': instance.originAmount,
      'stockQuantity': instance.stockQuantity,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BundleStatusEnumMap = {
  BundleStatus.READY: 'READY',
  BundleStatus.ON_SALE: 'ON_SALE',
  BundleStatus.STOP_SELLING: 'STOP_SELLING',
  BundleStatus.REMOVED: 'REMOVED',
};

const _$CurrencyTypeEnumMap = {
  CurrencyType.DIAMOND: 'DIAMOND',
  CurrencyType.COIN: 'COIN',
  CurrencyType.CHIP: 'CHIP',
  CurrencyType.FREE: 'FREE',
  CurrencyType.EVENT: 'EVENT',
};
