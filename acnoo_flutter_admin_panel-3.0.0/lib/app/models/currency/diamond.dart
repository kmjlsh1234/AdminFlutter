import 'package:json_annotation/json_annotation.dart';
part 'diamond.g.dart';

@JsonSerializable()
class Diamond{
  final int userId;
  final int amount;

  Diamond(this.userId, this.amount);

  factory Diamond.fromJson(Map<String, dynamic> json) => _$DiamondFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondToJson(this);
}