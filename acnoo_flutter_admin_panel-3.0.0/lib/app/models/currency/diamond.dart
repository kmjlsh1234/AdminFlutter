import 'package:json_annotation/json_annotation.dart';
part 'diamond.g.dart';

@JsonSerializable(includeIfNull: false)
class Diamond{
  final int userId;
  final int amount;

  Diamond({required this.userId, required this.amount});

  factory Diamond.fromJson(Map<String, dynamic> json) => _$DiamondFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondToJson(this);
}