import 'package:json_annotation/json_annotation.dart';
part 'board_search_param.g.dart';

@JsonSerializable()
class BoardSearchParam{
  @JsonKey(includeIfNull: true)
  final String? boardType;
  @JsonKey(includeIfNull: true)
  final String? boardStatus;
  @JsonKey(includeIfNull: true)
  final String? searchDateType;
  @JsonKey(includeIfNull: true)
  final String? startDate;
  @JsonKey(includeIfNull: true)
  final String? endDate;
  final int page;
  final int limit;

  BoardSearchParam(this.boardType, this.boardStatus, this.searchDateType, this.startDate, this.endDate, this.page, this.limit);
  factory BoardSearchParam.fromJson(Map<String, dynamic> json) => _$BoardSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$BoardSearchParamToJson(this);
}