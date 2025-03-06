import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/currency_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemModParam {
  final int? categoryId;
  final String? sku;
  final String? name;
  final String? unitSku;
  final String? description;
  final int? num;
  final int? stockQuantity;
  final String? thumbnail;
  final String? image;
  final String? info;
  final ItemPeriodType? periodType;
  final int? period;
  final String? expiration;
  final CurrencyType? currencyType;
  final int? amount;

  ItemModParam({
        required this.categoryId,
        required this.sku,
        required this.name,
        required this.unitSku,
        required this.description,
        required this.num,
        required this.stockQuantity,
        required this.thumbnail,
        required this.image,
        required this.info,
        required this.periodType,
        required this.period,
        required this.expiration,
        required this.currencyType,
        required this.amount
      });

  factory ItemModParam.fromJson(Map<String, dynamic> json) => _$ItemModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModParamToJson(this);
}
