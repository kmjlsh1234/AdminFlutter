import 'package:acnoo_flutter_admin_panel/app/constants/menus/privilege/privilege_serach_type.dart';
import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'privilege_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class PrivilegeSearchParam extends PagingParam{
  final PrivilegeSearchType? searchType;
  final String? searchValue;

  PrivilegeSearchParam({
    required this.searchType,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page, limit);

  factory PrivilegeSearchParam.fromJson(Map<String, dynamic> json) => _$PrivilegeSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeSearchParamToJson(this);
}