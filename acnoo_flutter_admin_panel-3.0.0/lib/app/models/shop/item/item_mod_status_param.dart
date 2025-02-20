import 'package:json_annotation/json_annotation.dart';

part 'item_mod_status_param.g.dart';

@JsonSerializable(includeIfNull: false)
class ItemModStatusParam{
  final String status;

  ItemModStatusParam({required this.status});

  factory ItemModStatusParam.fromJson(Map<String, dynamic> json) => _$ItemModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModStatusParamToJson(this);
}