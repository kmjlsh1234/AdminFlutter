import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';
part 'board_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class BoardSearchParam extends PagingParam{
  final String? boardType;
  final String? boardStatus;
  final String? searchDateType;
  final String? startDate;
  final String? endDate;

  BoardSearchParam (
      this.boardType,
      this.boardStatus,
      this.searchDateType,
      this.startDate,
      this.endDate,
      int page,
      int limit,
      ) : super(page, limit);

  factory BoardSearchParam.fromJson(Map<String, dynamic> json) => _$BoardSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$BoardSearchParamToJson(this);
}