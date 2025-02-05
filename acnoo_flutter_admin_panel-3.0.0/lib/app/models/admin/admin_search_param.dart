import 'package:json_annotation/json_annotation.dart';
part 'admin_search_param.g.dart';
@JsonSerializable()
class AdminSearchParam {
  // keyword search
  @JsonKey(includeIfNull: true)
  final String? searchType;
  @JsonKey(includeIfNull: true)
  final String? searchValue;

  final int page;
  final int limit;

  AdminSearchParam(this.searchType, this.searchValue, this.page, this.limit);

  Map<String, dynamic> toJson() => _$AdminSearchParamToJson(this);
}