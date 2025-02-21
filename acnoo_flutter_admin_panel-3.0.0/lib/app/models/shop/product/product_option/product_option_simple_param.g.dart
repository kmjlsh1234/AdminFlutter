// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_option_simple_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOptionSimpleParam _$ProductOptionSimpleParamFromJson(
        Map<String, dynamic> json) =>
    ProductOptionSimpleParam(
      name: json['name'] as String,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ProductOptionSimpleParamToJson(
        ProductOptionSimpleParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'quantity': instance.quantity,
    };
