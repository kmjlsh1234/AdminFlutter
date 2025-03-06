import 'package:json_annotation/json_annotation.dart';

import 'base_currency_model.dart';
part 'chips.g.dart';

@JsonSerializable(includeIfNull: false)
class Chips extends BaseCurrencyModel{

  Chips({
    required super.userId,
    required super.amount
  });

  factory Chips.fromJson(Map<String, dynamic> json) => _$ChipsFromJson(json);
  Map<String, dynamic> toJson() => _$ChipsToJson(this);
}