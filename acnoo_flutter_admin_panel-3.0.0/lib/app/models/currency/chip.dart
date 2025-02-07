import 'package:json_annotation/json_annotation.dart';
part 'chip.g.dart';

@JsonSerializable()
class Chip{
  final int userId;
  final int amount;

  Chip(this.userId, this.amount);

  factory Chip.fromJson(Map<String, dynamic> json) => _$ChipFromJson(json);
  Map<String, dynamic> toJson() => _$ChipToJson(this);
}