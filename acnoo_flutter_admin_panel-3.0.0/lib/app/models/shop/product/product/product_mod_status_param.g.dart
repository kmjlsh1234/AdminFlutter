// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_mod_status_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModStatusParam _$ProductModStatusParamFromJson(
        Map<String, dynamic> json) =>
    ProductModStatusParam(
      status: $enumDecode(_$ProductStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ProductModStatusParamToJson(
        ProductModStatusParam instance) =>
    <String, dynamic>{
      'status': _$ProductStatusEnumMap[instance.status]!,
    };

const _$ProductStatusEnumMap = {
  ProductStatus.NONE: 'NONE',
  ProductStatus.READY: 'READY',
  ProductStatus.ON_SALE: 'ON_SALE',
  ProductStatus.STOP_SELLING: 'STOP_SELLING',
  ProductStatus.REMOVED: 'REMOVED',
};
