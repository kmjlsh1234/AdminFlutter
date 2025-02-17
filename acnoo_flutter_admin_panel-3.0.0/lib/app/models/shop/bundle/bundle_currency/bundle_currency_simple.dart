import 'package:json_annotation/json_annotation.dart';

part 'bundle_currency_simple.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleCurrencySimple{
  final String currencyType;
  final int count;

  BundleCurrencySimple({
    required this.currencyType,
    required this.count
  });

  factory BundleCurrencySimple.fromJson(Map<String, dynamic> json) => _$BundleCurrencySimpleFromJson(json);
  Map<String, dynamic> toJson() => _$BundleCurrencySimpleToJson(this);
}