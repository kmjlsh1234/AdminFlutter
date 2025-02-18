import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_unit_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemUnitSearchParam extends PagingParam {
  final String? itemUnitType;
  final String? searchType;
  final String? searchValue;
  final String? searchDateType;
  final String? startDate;
  final String? endDate;

  ItemUnitSearchParam({
    required this.itemUnitType,
    required this.searchType,
    required this.searchValue,
    required this.searchDateType,
    required this.startDate,
    required this.endDate,
    required int page,
    required int limit
  }) : super(page,limit);

  factory ItemUnitSearchParam.fromJson(Map<String, dynamic> json) => _$ItemUnitSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemUnitSearchParamToJson(this);
}
