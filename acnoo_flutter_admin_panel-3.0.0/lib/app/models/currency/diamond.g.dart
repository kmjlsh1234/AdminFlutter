// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Diamond _$DiamondFromJson(Map<String, dynamic> json) => Diamond(
      userId: (json['userId'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$DiamondToJson(Diamond instance) => <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
    };
