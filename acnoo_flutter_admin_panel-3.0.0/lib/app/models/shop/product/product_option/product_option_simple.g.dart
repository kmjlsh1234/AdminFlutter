// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionSimple _$ProductOptionSimpleFromJson(Map<String, dynamic> json) =>
    ProductOptionSimple(
      name: json['name'] as String,
      type: $enumDecode(_$ProductOptionTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ProductOptionSimpleToJson(
        ProductOptionSimple instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$ProductOptionTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
    };

const _$ProductOptionTypeEnumMap = {
  ProductOptionType.DIAMOND: 'DIAMOND',
  ProductOptionType.COIN: 'COIN',
  ProductOptionType.ITEM: 'ITEM',
};
