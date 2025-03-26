// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    ProductDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$ProductStatusEnumMap, json['status']),
      thumbnail: json['thumbnail'] as String,
      image: json['image'] as String,
      info: json['info'] as String,
      type: $enumDecode(_$ProductTypeEnumMap, json['type']),
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      price: (json['price'] as num).toInt(),
      originPrice: (json['originPrice'] as num).toInt(),
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': _$ProductStatusEnumMap[instance.status]!,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'info': instance.info,
      'type': _$ProductTypeEnumMap[instance.type]!,
      if (instance.stockQuantity case final value?) 'stockQuantity': value,
      'price': instance.price,
      'originPrice': instance.originPrice,
      'options': instance.options,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ProductStatusEnumMap = {
  ProductStatus.NONE: 'NONE',
  ProductStatus.READY: 'READY',
  ProductStatus.ON_SALE: 'ON_SALE',
  ProductStatus.STOP_SELLING: 'STOP_SELLING',
  ProductStatus.REMOVED: 'REMOVED',
};

const _$ProductTypeEnumMap = {
  ProductType.CURRENCY: 'CURRENCY',
};
