// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitAddParam _$ItemUnitAddParamFromJson(Map<String, dynamic> json) =>
    ItemUnitAddParam(
      json['sku'] as String,
      json['name'] as String,
      json['image'] as String,
      json['description'] as String,
      json['attributes'] as String,
      json['type'] as String,
    );

Map<String, dynamic> _$ItemUnitAddParamToJson(ItemUnitAddParam instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'attributes': instance.attributes,
      'type': instance.type,
    };
