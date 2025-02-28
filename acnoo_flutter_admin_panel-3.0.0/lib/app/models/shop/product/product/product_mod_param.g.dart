// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModParam _$ProductModParamFromJson(Map<String, dynamic> json) =>
    ProductModParam(
      name: json['name'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      image: json['image'] as String?,
      info: json['info'] as String?,
      type: json['type'] as String?,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      originPrice: (json['originPrice'] as num?)?.toInt(),
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
