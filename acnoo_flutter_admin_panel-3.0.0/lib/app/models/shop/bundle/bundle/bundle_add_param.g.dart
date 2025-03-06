// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleAddParam _$BundleAddParamFromJson(Map<String, dynamic> json) =>
    BundleAddParam(
      name: json['name'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      countPerPerson: (json['countPerPerson'] as num?)?.toInt(),
      saleStartDate: json['saleStartDate'] as String?,
      saleEndDate: json['saleEndDate'] as String?,
      currencyType: $enumDecode(_$CurrencyTypeEnumMap, json['currencyType']),
      amount: (json['amount'] as num).toInt(),
      originAmount: (json['originAmount'] as num).toInt(),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BundleAddParamToJson(BundleAddParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sku': instance.sku,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'countPerPerson': instance.countPerPerson,
      'saleStartDate': instance.saleStartDate,
      'saleEndDate': instance.saleEndDate,
      'currencyType': _$CurrencyTypeEnumMap[instance.currencyType]!,
      'amount': instance.amount,
      'originAmount': instance.originAmount,
      'stockQuantity': instance.stockQuantity,
    };

const _$CurrencyTypeEnumMap = {
  CurrencyType.DIAMOND: 'DIAMOND',
  CurrencyType.COIN: 'COIN',
  CurrencyType.CHIP: 'CHIP',
  CurrencyType.FREE: 'FREE',
  CurrencyType.EVENT: 'EVENT',
};
