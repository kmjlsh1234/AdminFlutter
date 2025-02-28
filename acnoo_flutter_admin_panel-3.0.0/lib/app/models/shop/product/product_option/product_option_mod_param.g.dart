// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_mod_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionModParam _$ProductOptionModParamFromJson(
        Map<String, dynamic> json) =>
    ProductOptionModParam(
      (json['productOptions'] as List<dynamic>)
          .map((e) => ProductOptionSimple.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOptionModParamToJson(
        ProductOptionModParam instance) =>
    <String, dynamic>{
      'productOptions': instance.productOptions,
    };
