// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin(
      (json['userId'] as num).toInt(),
      (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
    };
