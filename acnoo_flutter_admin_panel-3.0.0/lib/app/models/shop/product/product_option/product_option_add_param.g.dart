// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionAddParam _$ProductOptionAddParamFromJson(
        Map<String, dynamic> json) =>
    ProductOptionAddParam(
      productOptions: (json['productOptions'] as List<dynamic>)
          .map((e) => ProductOptionSimple.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOptionAddParamToJson(
        ProductOptionAddParam instance) =>
    <String, dynamic>{
      'productOptions': instance.productOptions,
    };
