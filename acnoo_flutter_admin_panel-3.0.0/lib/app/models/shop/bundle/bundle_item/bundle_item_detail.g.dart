// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_item_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItemDetail _$BundleItemDetailFromJson(Map<String, dynamic> json) =>
    BundleItemDetail(
      (json['bundleId'] as num).toInt(),
      (json['itemId'] as num).toInt(),
      (json['count'] as num).toInt(),
      DateTime.parse(json['createdAt'] as String),
      Item.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BundleItemDetailToJson(BundleItemDetail instance) =>
    <String, dynamic>{
      'bundleId': instance.bundleId,
      'itemId': instance.itemId,
      'count': instance.count,
      'createdAt': instance.createdAt.toIso8601String(),
      'item': instance.item,
    };
