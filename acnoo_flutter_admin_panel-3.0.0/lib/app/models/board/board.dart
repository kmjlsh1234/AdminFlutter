import 'package:json_annotation/json_annotation.dart';
part 'board.g.dart';

@JsonSerializable(includeIfNull: true)
class Board{
  final int id;
  final String title;
  final String content;
  final String boardType;
  final String status;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Board({
    required this.id,
    required this.title,
    required this.content,
    required this.boardType,
    required this.status,
    this.image,
    required this.createdAt,
    required this.updatedAt
  });

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}