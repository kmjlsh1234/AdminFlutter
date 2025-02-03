import 'package:json_annotation/json_annotation.dart';
part 'admin.g.dart';

@JsonSerializable()
class Admin{
  final int adminId;
  @JsonKey(includeIfNull: true)
  final int? roleId;
  final String status;
  final String email;
  final String name;
  final String mobile;
  @JsonKey(includeIfNull: true)
  final String? loginAt;
  final String createdAt;
  final String updatedAt;

  Admin({
    required this.adminId,
    this.roleId,
    required this.status,
    required this.email,
    required this.name,
    required this.mobile,
    this.loginAt,
    required this.createdAt,
    required this.updatedAt
  });

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);
  Map<String, dynamic> toJson() => _$AdminToJson(this);
}