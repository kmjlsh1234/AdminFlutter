import 'package:json_annotation/json_annotation.dart';
part 'currency_mod_param.g.dart';

@JsonSerializable(includeIfNull: false)
class CurrencyModParam{
  final int amount;

  CurrencyModParam({required this.amount});

  factory CurrencyModParam.fromJson(Map<String, dynamic> json) => _$CurrencyModParamFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyModParamToJson(this);
}