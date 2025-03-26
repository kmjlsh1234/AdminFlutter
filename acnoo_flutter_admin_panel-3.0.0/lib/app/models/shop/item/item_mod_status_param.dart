import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_mod_status_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ItemModStatusParam{
  final ItemStatus status;

  ItemModStatusParam({required this.status});

  factory ItemModStatusParam.fromJson(Map<String, dynamic> json) => _$ItemModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModStatusParamToJson(this);
}