import 'package:json_annotation/json_annotation.dart';

part 'count_vo.g.dart';
@JsonSerializable()
class CountVo {
  final int count;

  CountVo(this.count);

  factory CountVo.fromJson(Map<String, dynamic> json) => _$CountVoFromJson(json);
}