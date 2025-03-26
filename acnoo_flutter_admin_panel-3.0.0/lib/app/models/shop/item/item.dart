import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_status.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../constants/shop/item/currency_type.dart';

part 'item.g.dart';

@JsonSerializable(includeIfNull: true)
class Item {
  final int id;
  final int categoryId;
  final int? itemUnitId;
  final String sku;
  final String? unitSku;
  final String name;
  final String description;
  final int? num;
  final int? stockQuantity;
  final ItemStatus status;
  final String thumbnail;
  final String image;
  final String info;
  final ItemPeriodType periodType;
  final int? period;
  final DateTime? expiration;
  final CurrencyType currencyType;
  final int? amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.categoryId,
    required this.itemUnitId,
    required this.sku,
    required this.unitSku,
    required this.name,
    required this.description,
    required this.num,
    required this.stockQuantity,
    required this.status,
    required this.thumbnail,
    required this.image,
    required this.info,
    required this.periodType,
    required this.period,
    required this.expiration,
    required this.currencyType,
    required this.amount,
    required this.createdAt,
    required this.updatedAt
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
