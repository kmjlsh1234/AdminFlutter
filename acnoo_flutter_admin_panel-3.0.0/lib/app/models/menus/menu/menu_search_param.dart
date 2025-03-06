import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../constants/menus/menu/menu_search_type.dart';
part 'menu_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class MenuSearchParam extends PagingParam{
  final MenuSearchType? searchType;
  final String? searchValue;
  final MenuVisibility? visibility;

  MenuSearchParam({
    required this.searchType,
    required this.searchValue,
    required this.visibility,
    required int page,
    required int limit
  }) : super(page, limit);

  factory MenuSearchParam.fromJson(Map<String, dynamic> json) => _$MenuSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$MenuSearchParamToJson(this);
}