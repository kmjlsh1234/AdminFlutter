import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/admin/admin_search_type.dart';
part 'admin_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class AdminSearchParam extends PagingParam{
  final int? roleId;
  final AdminSearchType? searchType;
  final String? searchValue;

  AdminSearchParam({
    required this.roleId,
    required this.searchType,
    required this.searchValue,
    required int page,
    required int limit,
  }) : super(page, limit);

  Map<String, dynamic> toJson() => _$AdminSearchParamToJson(this);
}