// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOption _$ProductOptionFromJson(Map<String, dynamic> json) =>
    ProductOption(
      id: (json['id'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      name: json['name'] as String,
      type: $enumDecode(_$ProductOptionTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'type': _$ProductOptionTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ProductOptionTypeEnumMap = {
  ProductOptionType.DIAMOND: 'DIAMOND',
  ProductOptionType.COIN: 'COIN',
  ProductOptionType.ITEM: 'ITEM',
};
