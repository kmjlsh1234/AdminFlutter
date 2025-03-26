import 'package:json_annotation/json_annotation.dart';

import '../../constants/board/board_status.dart';
import '../../constants/board/board_type.dart';
part 'board_add_param.g.dart';

@JsonSerializable(includeIfNull:  true)
class BoardAddParam{
  final String title;
  final String content;
  final BoardType boardType;
  final BoardStatus status;
  final String? image;

  BoardAddParam({
    required this.title,
    required this.content,
    required this.boardType,
    required this.status,
    this.image
  });

  factory BoardAddParam.fromJson(Map<String, dynamic> json) => _$BoardAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$BoardAddParamToJson(this);
}