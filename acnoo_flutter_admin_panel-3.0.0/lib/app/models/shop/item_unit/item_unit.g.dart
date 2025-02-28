// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnit _$ItemUnitFromJson(Map<String, dynamic> json) => ItemUnit(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      attributes: json['attributes'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemUnitToJson(ItemUnit instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'attributes': instance.attributes,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
