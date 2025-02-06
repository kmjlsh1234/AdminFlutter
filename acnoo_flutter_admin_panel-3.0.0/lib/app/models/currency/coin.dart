import 'package:json_annotation/json_annotation.dart';
part 'coin.g.dart';

@JsonSerializable()
class Coin{
  final int userId;
  final int amount;

  Coin(this.userId, this.amount);

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
  Map<String, dynamic> toJson() => _$CoinToJson(this);
}