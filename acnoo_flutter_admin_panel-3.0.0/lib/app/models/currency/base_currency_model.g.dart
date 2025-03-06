// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseCurrencyModel _$BaseCurrencyModelFromJson(Map<String, dynamic> json) =>
    BaseCurrencyModel(
      userId: (json['userId'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$BaseCurrencyModelToJson(BaseCurrencyModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
    };
