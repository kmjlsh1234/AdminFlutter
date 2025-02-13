import 'package:json_annotation/json_annotation.dart';

part 'user_mod_status_param.g.dart';

@JsonSerializable()
class UserModStatusParam{
  final String status;

  UserModStatusParam(this.status);
  factory UserModStatusParam.fromJson(Map<String, dynamic> json) => _$UserModStatusParamFromJson(json);
  Map<String, dynamic> toJson() => _$UserModStatusParamToJson(this);
}