import 'package:json_annotation/json_annotation.dart';
part 'board_add_param.g.dart';

@JsonSerializable()
class BoardAddParam{
  final String title;
  final String content;
  final String boardType;
  final String status;
  @JsonKey(includeIfNull: true)
  final String? image;

  BoardAddParam(this.title, this.content, this.boardType, this.status, this.image);

  factory BoardAddParam.fromJson(Map<String, dynamic> json) => _$BoardAddParamFromJson(json);
  Map<String, dynamic> toJson() => _$BoardAddParamToJson(this);
}