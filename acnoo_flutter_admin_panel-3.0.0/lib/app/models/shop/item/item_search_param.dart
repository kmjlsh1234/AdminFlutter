import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class ItemSearchParam extends PagingParam{
  final String? searchType;
  final String? searchValue;

  ItemSearchParam({
    required this.searchType,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page, limit);

  factory ItemSearchParam.fromJson(Map<String, dynamic> json) => _$ItemSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemSearchParamToJson(this);
}