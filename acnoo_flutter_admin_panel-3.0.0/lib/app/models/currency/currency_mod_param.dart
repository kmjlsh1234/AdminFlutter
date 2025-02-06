import 'package:json_annotation/json_annotation.dart';
part 'currency_mod_param.g.dart';

@JsonSerializable()
class CurrencyModParam{
  final int amount;

  CurrencyModParam(this.amount);

  factory CurrencyModParam.fromJson(Map<String, dynamic> json) => _$CurrencyModParamFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyModParamToJson(this);
}