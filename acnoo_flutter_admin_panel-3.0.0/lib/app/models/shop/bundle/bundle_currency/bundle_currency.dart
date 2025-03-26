import 'package:json_annotation/json_annotation.dart';

import '../../../../constants/shop/item/currency_type.dart';

part 'bundle_currency.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleCurrency {
  final int id;
  final int bundleId;
  final CurrencyType currencyType;
  final int count;
  final DateTime createdAt;

  BundleCurrency({
    required this.id,
    required this.bundleId,
    required this.currencyType,
    required this.count,
    required this.createdAt
  });

  factory BundleCurrency.fromJson(Map<String, dynamic> json) => _$BundleCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$BundleCurrencyToJson(this);
}