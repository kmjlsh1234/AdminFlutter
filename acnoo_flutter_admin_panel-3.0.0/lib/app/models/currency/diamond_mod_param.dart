import 'package:json_annotation/json_annotation.dart';
part 'diamond_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class DiamondModParam {
  final int? freeAmount;
  final int? androidAmount;
  final int? iosAmount;
  final int? paidAmount;

  DiamondModParam({required this.freeAmount, required this.androidAmount, required this.iosAmount, required this.paidAmount});

  factory DiamondModParam.fromJson(Map<String, dynamic> json) => _$DiamondModParamFromJson(json);
  Map<String, dynamic> toJson() => _$DiamondModParamToJson(this);
}