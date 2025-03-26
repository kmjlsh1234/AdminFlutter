import 'package:acnoo_flutter_admin_panel/app/models/currency/base_currency_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'diamonds.g.dart';

@JsonSerializable(includeIfNull: false)
class Diamonds extends BaseCurrencyModel{
  final int freeAmount;
  final int androidAmount;
  final int iosAmount;
  final int paidAmount;

  Diamonds({
    required int userId,
    required this.freeAmount,
    required this.androidAmount,
    required this.iosAmount,
    required this.paidAmount,
  }) : super(userId: userId, amount: freeAmount + androidAmount + iosAmount + paidAmount);

  factory Diamonds.fromJson(Map<String, dynamic> json) => _$DiamondsFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondsToJson(this);
}