import 'package:json_annotation/json_annotation.dart';
part 'admin_mod_param.g.dart';
@JsonSerializable(includeIfNull: true)
class AdminModParam{
  final int? roleId;
  final String? email;
  final String? password;
  final String? name;
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