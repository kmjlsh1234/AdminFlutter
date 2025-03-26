// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamonds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Diamonds _$DiamondsFromJson(Map<String, dynamic> json) => Diamonds(
      userId: (json['userId'] as num).toInt(),
      freeAmount: (json['freeAmount'] as num).toInt(),
      androidAmount: (json['androidAmount'] as num).toInt(),
      iosAmount: (json['iosAmount'] as num).toInt(),
      paidAmount: (json['paidAmount'] as num).toInt(),
    );

Map<String, dynamic> _$DiamondsToJson(Diamonds instance) => <String, dynamic>{
      'userId': instance.userId,
      'freeAmount': instance.freeAmount,
      'androidAmount': instance.androidAmount,
      'iosAmount': instance.iosAmount,
      'paidAmount': instance.paidAmount,
    };
