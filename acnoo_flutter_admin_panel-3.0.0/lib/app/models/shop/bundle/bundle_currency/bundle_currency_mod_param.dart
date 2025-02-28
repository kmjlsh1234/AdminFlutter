import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_currency/bundle_currency_simple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundle_currency_mod_param.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleCurrencyModParam{
  final List<BundleCurrencySimple> bundleCurrencies;

  BundleCurrencyModParam({required this.bundleCurrencies});

  factory BundleCurrencyModParam.fromJson(Map<String, dynamic> json) => _$BundleCurrencyModParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleCurrencyModParamToJson(this);
}