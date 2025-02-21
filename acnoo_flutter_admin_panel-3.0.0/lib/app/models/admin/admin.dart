import 'package:json_annotation/json_annotation.dart';
part 'admin.g.dart';

@JsonSerializable(includeIfNull: true)
class Admin{
  final int adminId;
  final int? roleId;
  final String status;
  final String email;
  final String name;
  final String mobile;
  final DateTime? loginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

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