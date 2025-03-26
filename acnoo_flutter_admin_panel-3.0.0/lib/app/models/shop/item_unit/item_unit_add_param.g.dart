// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitAddParam _$ItemUnitAddParamFromJson(Map<String, dynamic> json) =>
    ItemUnitAddParam(
      sku: json['sku'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      attributes: json['attributes'] as String,
      type: $enumDecode(_$ItemUnitTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ItemUnitAddParamToJson(ItemUnitAddParam instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'attributes': instance.attributes,
      'type': _$ItemUnitTypeEnumMap[instance.type]!,
    };

const _$ItemUnitTypeEnumMap = {
  ItemUnitType.CONSUMABLE: 'CONSUMABLE',
  ItemUnitType.PERMANENT: 'PERMANENT',
  ItemUnitType.EXPIRATION: 'EXPIRATION',
};
