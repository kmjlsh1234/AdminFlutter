import 'package:json_annotation/json_annotation.dart';

part 'bundle_item_simple.g.dart';

@JsonSerializable(includeIfNull: true)
class BundleItemSimple{
  final int bundleId;
  final int itemId;
  final int count;

  BundleItemSimple({
    required this.bundleId,
    required this.itemId,
    required this.count
  });

  factory BundleItemSimple.fromJson(Map<String, dynamic> json) => _$BundleItemSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$BundleItemSimpleToJson(this);
}