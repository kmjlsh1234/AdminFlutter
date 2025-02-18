import 'package:json_annotation/json_annotation.dart';
part 'chip.g.dart';

@JsonSerializable(includeIfNull: false)
class Chip{
  final int userId;
  final int amount;

  Chip({required this.userId, required this.amount});

  factory Chip.fromJson(Map<String, dynamic> json) => _$ChipFromJson(json);
  Map<String, dynamic> toJson() => _$ChipToJson(this);
}