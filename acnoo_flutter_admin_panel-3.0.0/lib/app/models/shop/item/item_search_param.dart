import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_status.dart';
import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemSearchParam extends PagingParam{
  final int? categoryId;
  final ItemStatus? searchStatus;
  final ItemSearchType? searchType;
  final String? searchValue;

  ItemSearchParam({
    required this.categoryId,
    required this.searchStatus,
    required this.searchType,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page, limit);

  factory ItemSearchParam.fromJson(Map<String, dynamic> json) => _$ItemSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemSearchParamToJson(this);
}