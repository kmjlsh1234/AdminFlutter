import 'package:json_annotation/json_annotation.dart';
part 'board.g.dart';

@JsonSerializable()
class Board{
  final int id;
  final String title;
  final String content;
  final String boardType;
  final String status;
  @JsonKey(includeIfNull: true)
  final String? image;
  final String createdAt;
  final String updatedAt;

  Board(this.id, this.title, this.content, this.boardType, this.status, this.image, this.createdAt, this.updatedAt);
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}