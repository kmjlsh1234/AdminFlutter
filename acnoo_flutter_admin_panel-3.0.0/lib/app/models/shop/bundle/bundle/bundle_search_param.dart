import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bundle_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class BundleSearchParam extends PagingParam{
  final String? searchStatus;
  final String? searchType;
  final String? searchValue;

  BundleSearchParam({
    required this.searchStatus,
    required this.searchType,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page, limit);

  factory BundleSearchParam.fromJson(Map<String, dynamic> json) => _$BundleSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$BundleSearchParamToJson(this);
}