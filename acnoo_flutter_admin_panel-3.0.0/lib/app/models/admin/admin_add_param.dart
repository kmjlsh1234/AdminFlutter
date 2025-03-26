import 'package:json_annotation/json_annotation.dart';
part 'admin_add_param.g.dart';

@JsonSerializable(includeIfNull: false)
class AdminAddParam{
  final int? roleId;
  final String email;
  final String password;
  final String name;
  final String mobile;

  AdminAddParam({
    required this.roleId,
    required this.email,
    required this.password,
    required this.name,
    required this.mobile
  });

  Map<String, dynamic> toJson() => _$AdminAddParamToJson(this);
}