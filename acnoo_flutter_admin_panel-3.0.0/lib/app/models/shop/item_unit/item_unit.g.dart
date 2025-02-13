// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnit _$ItemUnitFromJson(Map<String, dynamic> json) => ItemUnit(
      (json['id'] as num).toInt(),
      json['sku'] as String,
      json['name'] as String,
      json['image'] as String,
      json['description'] as String,
      json['attributes'] as String,
      json['type'] as String,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
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
