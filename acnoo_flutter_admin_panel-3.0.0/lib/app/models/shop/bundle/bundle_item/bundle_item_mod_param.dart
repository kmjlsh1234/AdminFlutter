import 'package:acnoo_flutter_admin_panel/app/models/shop/bundle/bundle_item/bundle_item_simple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundle_item_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class BundleItemModParam{
  final List<BundleItemSimple> bundleItems;

  BundleItemModParam({required this.bundleItems});

  factory BundleItemModParam.fromJson(Map<String, dynamic> json) => _$BundleItemModParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleItemModParamToJson(this);
}