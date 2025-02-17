// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_item_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItemSimple _$BundleItemSimpleFromJson(Map<String, dynamic> json) =>
    BundleItemSimple(
      bundleId: (json['bundleId'] as num).toInt(),
      itemId: (json['itemId'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$BundleItemSimpleToJson(BundleItemSimple instance) =>
    <String, dynamic>{
      'bundleId': instance.bundleId,
      'itemId': instance.itemId,
      'count': instance.count,
    };
