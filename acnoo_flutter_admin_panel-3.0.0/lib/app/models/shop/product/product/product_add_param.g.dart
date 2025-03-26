// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAddParam _$ProductAddParamFromJson(Map<String, dynamic> json) =>
    ProductAddParam(
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      type: $enumDecode(_$ProductTypeEnumMap, json['type']),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      price: (json['price'] as num).toInt(),
      originPrice: (json['originPrice'] as num).toInt(),
    );

Map<String, dynamic> _$ProductAddParamToJson(ProductAddParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'type': _$ProductTypeEnumMap[instance.type]!,
      'stockQuantity': instance.stockQuantity,
      'price': instance.price,
      'originPrice': instance.originPrice,
    };

const _$ProductTypeEnumMap = {
  ProductType.CURRENCY: 'CURRENCY',
};
