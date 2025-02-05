import 'package:json_annotation/json_annotation.dart';
part 'admin_mod_param.g.dart';
@JsonSerializable()
class AdminModParam{
  @JsonKey(includeIfNull: true)
  final int? roleId;
  @JsonKey(includeIfNull: true)
  final String? email;
  @JsonKey(includeIfNull: true)
  final String? password;
  @JsonKey(includeIfNull: true)
  final String? name;
  @JsonKey(includeIfNull: true)
  final String? mobile;

  AdminModParam({
    this.roleId,
    this.email,
    this.password,
    this.name,
    this.mobile
  });

  Map<String, dynamic> toJson() => _$AdminModParamToJson(this);
}