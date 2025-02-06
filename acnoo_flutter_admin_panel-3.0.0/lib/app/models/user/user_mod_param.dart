import 'package:json_annotation/json_annotation.dart';
part 'user_mod_param.g.dart';

@JsonSerializable()
class UserModParam{
  @JsonKey(includeIfNull: true)
  final String? password;
  @JsonKey(includeIfNull: true)
  final String? mobile;
  @JsonKey(includeIfNull: true)
  final String? email;
  @JsonKey(includeIfNull: true)
  final String? userType;

  UserModParam(this.password, this.mobile, this.email, this.userType);

  factory UserModParam.fromJson(Map<String, dynamic> json) => _$UserModParamFromJson(json);
  Map<String, dynamic> toJson() => _$UserModParamToJson(this);
}