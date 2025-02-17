import 'package:json_annotation/json_annotation.dart';

part 'item_add_param.g.dart';

@JsonSerializable()
class ItemAddParam {
  final int categoryId;
  final String sku;
  @JsonKey(includeIfNull: true)
  final String unitSku;
  final String name;
  final String description;
  @JsonKey(includeIfNull: true)
  final int num;
  @JsonKey(includeIfNull: true)
  final int stockQuantity;
  final String thumbnail;
  final String image;
  final String info;
  final String periodType; // none, day, expiration
  @JsonKey(includeIfNull: true)
  final int period;
  @JsonKey(includeIfNull: true)
  final String expiration;
  final String currencyType;
  final int amount;

  ItemAddParam(
      this.categoryId,
      this.unitSku,
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
      this.amount);

  factory ItemAddParam.fromJson(Map<String, dynamic> json) =>
      _$ItemAddParamFromJson(json);

  Map<String, dynamic> toJson() => _$ItemAddParamToJson(this);
}
