import 'package:json_annotation/json_annotation.dart';
part 'item.g.dart';

@JsonSerializable()
class Item{
  final int id;
  final int categoryId;
  @JsonKey(includeIfNull: true)
  final int? itemUnitId;
  final String sku;
  @JsonKey(includeIfNull: true)
  final String? unitSku;
  final String name;
  final String description;
  @JsonKey(includeIfNull: true)
  final int? num;
  @JsonKey(includeIfNull: true)
  final int? stockQuantity;
  final String status;
  final String thumbnail;
  final String image;
  final String info;
  final String periodType; // none, day, expiration
  @JsonKey(includeIfNull: true)
  final int? period;
  @JsonKey(includeIfNull: true)
  final DateTime? expiration;
  final String currencyType;
  @JsonKey(includeIfNull: true)
  final int? amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item(this.id, this.categoryId, this.itemUnitId, this.sku, this.unitSku, this.name, this.description, this.num, this.stockQuantity, this.status, this.thumbnail, this.image, this.info, this.periodType, this.period, this.expiration, this.currencyType, this.amount, this.createdAt, this.updatedAt);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}