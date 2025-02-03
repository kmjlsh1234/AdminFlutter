import 'package:json_annotation/json_annotation.dart';
part 'admin_join_param.g.dart';

@JsonSerializable()
class AdminJoinParam{
  final String email;
  final String password;
  final String name;
  final String mobile;

  AdminJoinParam({
    required this.email,
    required this.password,
    required this.name,
    required this.mobile
  });

  Map<String, dynamic> toJson() => _$AdminJoinParamToJson(this);
}