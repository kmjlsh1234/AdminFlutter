// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModParam _$ProductModParamFromJson(Map<String, dynamic> json) =>
    ProductModParam(
      json['name'] as String?,
      json['description'] as String?,
      json['thumbnail'] as String?,
      json['image'] as String?,
      json['info'] as String?,
      json['type'] as String?,
      (json['stockQuantity'] as num?)?.toInt(),
      (json['price'] as num?)?.toInt(),
      (json['originPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductModParamToJson(ProductModParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'type': instance.type,
      'stockQuantity': instance.stockQuantity,
      'price': instance.price,
      'originPrice': instance.originPrice,
    };
