import 'package:acnoo_flutter_admin_panel/app/constants/board/board_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'board_simple.g.dart';

@JsonSerializable(includeIfNull: true)
class BoardSimple{
  final int id;
  final String title;
  final BoardStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoardSimple({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  factory BoardSimple.fromJson(Map<String, dynamic> json) => _$BoardSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$BoardSimpleToJson(this);
}