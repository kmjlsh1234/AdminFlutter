// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chip _$ChipFromJson(Map<String, dynamic> json) => Chip(
      userId: (json['userId'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$ChipToJson(Chip instance) => <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
    };
