import 'package:acnoo_flutter_admin_panel/app/constants/user/login_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/user/user_search_date_type.dart';
import 'package:acnoo_flutter_admin_panel/app/constants/user/user_status.dart';
import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/user/user_search_type.dart';
part 'user_search_param.g.dart';
@JsonSerializable(includeIfNull: true)
class UserSearchParam extends PagingParam{

  final UserStatus? searchStatus;
  final LoginType? loginType;
  // keyword search
  final UserSearchType? searchType;
  final String? searchValue;

  // date search
  final UserSearchDateType? searchDateType;
  final String? startDate;
  final String? endDate;

  UserSearchParam({
    required this.searchStatus,
    required this.loginType,
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