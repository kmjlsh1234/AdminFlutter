import 'package:acnoo_flutter_admin_panel/app/constants/board/board_status.dart';
import 'package:acnoo_flutter_admin_panel/app/models/common/paging_param.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/board/board_type.dart';
part 'board_search_param.g.dart';

@JsonSerializable(includeIfNull: true)
class BoardSearchParam extends PagingParam{
  final BoardType? boardType;
  final BoardStatus? boardStatus;
  final String? searchValue;

  BoardSearchParam({
    required this.boardType,
    required this.boardStatus,
    required this.searchValue,
    required int page,
    required int limit
  }) : super(page, limit);


  factory BoardSearchParam.fromJson(Map<String, dynamic> json) => _$BoardSearchParamFromJson(json);
  Map<String, dynamic> toJson() => _$BoardSearchParamToJson(this);
}