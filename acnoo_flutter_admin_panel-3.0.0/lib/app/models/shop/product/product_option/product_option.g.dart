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
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductOptionToJson(ProductOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'name': instance.name,
      'type': instance.type,
      'quantity': instance.quantity,
      'createdAt': instance.createdAt.toIso8601String(),
    };
