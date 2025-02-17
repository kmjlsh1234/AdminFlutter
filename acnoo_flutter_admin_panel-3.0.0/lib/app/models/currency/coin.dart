import 'package:json_annotation/json_annotation.dart';
part 'coin.g.dart';

@JsonSerializable(includeIfNull: false)
class Coin{
  final int userId;
  final int amount;

  Coin({required this.userId, required this.amount});

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
  Map<String, dynamic> toJson() => _$CoinToJson(this);
}