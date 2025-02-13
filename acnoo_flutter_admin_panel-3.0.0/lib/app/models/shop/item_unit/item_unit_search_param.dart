import 'package:json_annotation/json_annotation.dart';

part 'item_unit_search_param.g.dart';

@JsonSerializable()
class ItemUnitSearchParam{
  @JsonKey(includeIfNull: true)
  final String? itemUnitType;
  @JsonKey(includeIfNull: true)
  final String? searchType;
  @JsonKey(includeIfNull: true)
  final String? searchValue;
  @JsonKey(includeIfNull: true)
  final String? searchDateType;
  @JsonKey(includeIfNull: true)
  final String? startDate;
  @JsonKey(includeIfNull: true)
  final String? endDate;
  final int page;
  final int limit;

  ItemUnitSearchParam(this.itemUnitType, this.searchType, this.searchValue, this.searchDateType, this.startDate, this.endDate, this.page, this.limit);

  factory ItemUnitSearchParam.fromJson(Map<String, dynamic> json) => _$ItemUnitSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitSearchParamToJson(this);
}