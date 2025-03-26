import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'coins.g.dart';

@JsonSerializable(includeIfNull: false)
class Coins extends BaseCurrencyModel{
  Coins({
    required super.userId,
    required super.amount
  });

  factory Coins.fromJson(Map<String, dynamic> json) => _$CoinsFromJson(json);
  Map<String, dynamic> toJson() => _$CoinsToJson(this);
}