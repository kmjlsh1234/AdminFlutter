import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/user/drop_out_user_search_type.dart';
part 'drop_out_user_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class DropOutUserSearchParam extends PagingParam {
  final DropOutUserSearchType? searchType;
  final String? searchValue;
  final String? startDate;
  final String? endDate;

  DropOutUserSearchParam({
    required this.searchType,
    required this.searchValue,
    required this.startDate,
    required this.endDate,
    required int page,
    required int limit
  }) : super(page, limit);

  factory DropOutUserSearchParam.fromJson(Map<String, dynamic> json) => _$DropOutUserSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$DropOutUserSearchParamToJson(this);
}