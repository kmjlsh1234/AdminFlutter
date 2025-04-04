// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitModParam _$ItemUnitModParamFromJson(Map<String, dynamic> json) =>
    ItemUnitModParam(
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      attributes: json['attributes'] as String?,
      type: $enumDecodeNullable(_$ItemUnitTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ItemUnitModParamToJson(ItemUnitModParam instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'attributes': instance.attributes,
      'type': _$ItemUnitTypeEnumMap[instance.type],
    };

const _$ItemUnitTypeEnumMap = {
  ItemUnitType.CONSUMABLE: 'CONSUMABLE',
  ItemUnitType.PERMANENT: 'PERMANENT',
  ItemUnitType.EXPIRATION: 'EXPIRATION',
};
