// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bundle_item_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BundleItemModParam _$BundleItemModParamFromJson(Map<String, dynamic> json) =>
    BundleItemModParam(
      bundleItems: (json['bundleItems'] as List<dynamic>)
          .map((e) => BundleItemSimple.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BundleItemModParamToJson(BundleItemModParam instance) =>
    <String, dynamic>{
      'bundleItems': instance.bundleItems,
    };
