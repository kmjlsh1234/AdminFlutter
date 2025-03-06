// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coins.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coins _$CoinsFromJson(Map<String, dynamic> json) => Coins(
      userId: (json['userId'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$CoinsToJson(Coins instance) => <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
    };
