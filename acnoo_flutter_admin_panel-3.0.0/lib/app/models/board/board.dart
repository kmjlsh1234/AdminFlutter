import 'package:acnoo_flutter_admin_panel/app/constants/board/board_status.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constants/board/board_type.dart';
part 'board.g.dart';

@JsonSerializable(includeIfNull: true)
class Board{
  final int id;
  final String title;
  final String content;
  final BoardType boardType;
  final BoardStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Board({
    required this.id,
    required this.title,
    required this.content,
    required this.boardType,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}