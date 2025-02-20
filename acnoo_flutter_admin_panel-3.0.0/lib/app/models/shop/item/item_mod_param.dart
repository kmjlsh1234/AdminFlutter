import 'package:json_annotation/json_annotation.dart';

part 'item_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemModParam{
  final int? categoryId;
  final int? itemUnitId;
  final String? sku;
  final String? name;
  final String? description;
  final int? num;
  final int? stockQuantity;
  final String? thumbnail;
  final String? image;
  final String? info;
  final String? periodType;
  final int? period;
  final String? expiration;
  final String? currencyType;
  final int? amount;

  ItemModParam(
      this.categoryId,
      this.itemUnitId,
      this.sku,
      this.name,
      this.description,
      this.num,
      this.stockQuantity,
      this.thumbnail,
      this.image,
      this.info,
      this.periodType,
      this.period,
      this.expiration,
      this.currencyType,
      this.amount
      );
  factory ItemModParam.fromJson(Map<String, dynamic> json) => _$ItemModParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModParamToJson(this);
}