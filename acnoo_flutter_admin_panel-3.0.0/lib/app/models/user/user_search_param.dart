import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_search_param.g.dart';
@JsonSerializable(includeIfNull: true)
class UserSearchParam extends PagingParam{
  // keyword search
  final String? searchType;
  final String? searchValue;

  // date search
  final String? searchDateType;
  final String? startDate;
  final String? endDate;

  UserSearchParam({
    required this.searchType,
    required this.searchValue,
    required this.searchDateType,
    required this.startDate,
    required this.endDate,
    required int page,
    required int limit
  }) : super(page, limit);

  factory UserSearchParam.fromJson(Map<String, dynamic> json) => _$UserSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$UserSearchParamToJson(this);
}