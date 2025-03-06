import 'package:json_annotation/json_annotation.dart';
part 'base_currency_model.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseCurrencyModel{
  final int userId;
  final int amount;

  BaseCurrencyModel({required this.userId, required this.amount});

  factory BaseCurrencyModel.fromJson(Map<String, dynamic> json) => _$BaseCurrencyModelFromJson(json);
  Map<String, dynamic> toJson() => _$BaseCurrencyModelToJson(this);
}