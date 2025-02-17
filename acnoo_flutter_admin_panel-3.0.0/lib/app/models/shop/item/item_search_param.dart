import 'package:json_annotation/json_annotation.dart';

part 'item_search_param.g.dart';

@JsonSerializable()
class ItemSearchParam{
  @JsonKey(includeIfNull: true)
  final String? categoryId;
  @JsonKey(includeIfNull: true)
  final String? searchType;
  @JsonKey(includeIfNull: true)
  final String? searchValue;
  final int page;
  final int limit;

  ItemSearchParam(this.categoryId, this.searchType, this.searchValue, this.page, this.limit);

  factory ItemSearchParam.fromJson(Map<String, dynamic> json) => _$ItemSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$ItemSearchParamToJson(this);
}