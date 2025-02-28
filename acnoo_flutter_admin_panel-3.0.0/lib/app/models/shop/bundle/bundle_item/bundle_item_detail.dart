import 'package:json_annotation/json_annotation.dart';

import '../../item/item.dart';

part 'bundle_item_detail.g.dart';

@JsonSerializable(includeIfNull: false)
class BundleItemDetail{
  final int bundleId;
  final int itemId;
  final int count;
  final DateTime createdAt;
  final Item item;

  BundleItemDetail(this.bundleId, this.itemId, this.count, this.createdAt, this.item);

  factory BundleItemDetail.fromJson(Map<String, dynamic> json) => _$BundleItemDetailFromJson(json);
  Map<String, dynamic> toJson() => _$BundleItemDetailToJson(this);
}