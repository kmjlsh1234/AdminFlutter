import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../constants/shop/item/currency_type.dart';

part 'item_add_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemAddParam {
  final int categoryId;
  final String sku;
  final String? unitSku;
  final String name;
  final String description;
  final int? num;
  final int? stockQuantity;
  final String thumbnail;
  final String image;
  final String info;
  final ItemPeriodType periodType;
  final int? period;
  final String? expiration;
  final CurrencyType currencyType;
  final int? amount;

  ItemAddParam({
    required this.categoryId,
    required this.sku,
    required this.unitSku,
    required this.name,
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

  factory ItemAddParam.fromJson(Map<String, dynamic> json) => _$ItemAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemAddParamToJson(this);
}
